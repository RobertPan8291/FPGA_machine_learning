volatile unsigned *hex = (volatile unsigned *) 0x00001010; /* hex display PIO */
volatile unsigned *wordcopy_acc = (volatile unsigned *) 0x00001040; /* memory copy accelerator */
volatile unsigned *act_acc      = (volatile unsigned *) 0x00001200; /* DOT product + activation function accelerator */
volatile      int *vga          = (volatile      int *) 0x00004000; /* VGA adapter base address */
volatile      int *bank0        = (volatile      int *) 0x00006000; /* SRAM bank0 */
volatile      int *bank1        = (volatile      int *) 0x00007000; /* SRAM bank1 */



/* normally these would be contiguous but it's nice to know where they are for debugging */
volatile int *nn      = (volatile int *) 0x08000000; /* neural network biases and weights */
volatile int *input   = (volatile int *) 0x08800000; /* input image */
volatile int *l1_acts = (volatile int *) 0x08801000; /* activations of layer 1 */
volatile int *l2_acts = (volatile int *) 0x08802000; /* activations of layer 2 */
volatile int *l3_acts = (volatile int *) 0x08803000; /* activations of layer 3 (outputs) */




void vga_plot(unsigned x, unsigned y, unsigned colour);


int SW = 0;

#define L1_IN  784
#define L1_OUT 1000
#define L2_IN L1_OUT
#define L2_OUT 1000
#define L3_IN L2_OUT
#define L3_OUT 10
#define NPARAMS (L1_OUT + L1_IN * L1_OUT + L2_OUT + L2_IN * L2_OUT + L3_OUT + L3_IN * L3_OUT)



int hex7seg(unsigned d) {
    const unsigned digits[] = { 0x40,  0x79, 0x24, 0x30, 0x19, 0x12, 0x02, 0x78, 0x00, 0x10 };
    return (d < 10) ? digits[d] : 0x3f;
}




// ----------------------------------------------------------------
// Two ways of copying memory

void wordcopy_hw(volatile int *dst, volatile int *src, int n_words)
{
    *(wordcopy_acc + 1) = (unsigned) dst;
    *(wordcopy_acc + 2) = (unsigned) src;
    *(wordcopy_acc + 3) = (unsigned) n_words;
    *wordcopy_acc = 0; /* start */   
    *wordcopy_acc; /* make sure the accelerator is finished */
}

// BASELINE
void wordcopy_sw( volatile int *dst, volatile int *src, int n_words )
{
    // software version of wordcopy()
    for( int i = 0; i < n_words; i++ ) {
        dst[i] = src[i];
    }
}

void wordcopy( volatile int *dst, volatile int *src, int n_words )
{
  #if ( DONE_TASK5 || DONE_TASK6 || DONE_TASK7 || DONE_TASK8 )
    wordcopy_hw( dst, src, n_words );
  #else
    wordcopy_sw( dst, src, n_words );
  #endif
}





// ----------------------------------------------------------------
// Two ways of computing dot product

// use accelerator hardware to compute the dot product of w[i]*ifmap[i]
// this hardware do the equivalent of function dotprod_sw()
int dotprod_hw(int n_in, volatile int *w, volatile int *ifmap)
{
    volatile unsigned* dotprod_acc = (volatile unsigned*)0x00001100; /* DOT product accelerator */
    int sum = 0;
    *(dotprod_acc + 2) = (unsigned) w;
    *(dotprod_acc + 3) = (unsigned) ifmap;
    *(dotprod_acc + 5) = (unsigned) n_in;
    *(dotprod_acc) = 0; /* start */
    sum = (int)*((volatile unsigned*)(0x00001100));

    return sum; /* make sure the accelerator is finished */
}

// BASELINE
// use software to compute the dot product of w[i]*ifmap[i]
int dotprod_sw(int n_in, volatile int *w, volatile int *ifmap)
{
        int sum = 0;
        for (unsigned i = 0; i < n_in; ++i) { /* Q16 dot product */
            sum += (int) (((long long) w[i] * (long long) ifmap[i]) >> 16);
        }
        return sum;
}



// ----------------------------------------------------------------

void apply_layer_dot(int n_in, int n_out, volatile int *b, volatile int *w, int use_relu, volatile int *ifmap, volatile int *ofmap)
{
    for (unsigned o = 0, wo = 0; o < n_out; ++o, wo += n_in) {
        int sum = b[o]; /* bias for the current output index */
      #if (SW == 0)
        sum += dotprod_hw( n_in, (volatile int *) (((unsigned int)(((unsigned char*)& w[wo]) - 0x08000000) / 4) + 0x08000000), (volatile int*)(((unsigned int)(((unsigned char*)ifmap) - 0x08000000) / 4) + 0x08000000));
      #else // BASELINE
        sum += dotprod_sw( n_in, &w[wo], ifmap );
      #endif
        if (use_relu) sum = (sum < 0) ? 0 : sum; /* ReLU activation */
        ofmap[o] = sum;
    }
}



// ----------------------------------------------------------------

int max_index(int n_in, volatile int *ifmap)
{
    int max_sofar = 0;
    for( int i = 1; i < n_in; ++i ) {
        if( ifmap[i] > ifmap[max_sofar] ) max_sofar = i;
    }
    return max_sofar;
}

void display_image( volatile int *image, int rows, int cols, int min_pixel_value_q1616, int max_pixel_value_q1616 )
{
    unsigned x, y;
    unsigned scale_range = (max_pixel_value_q1616 - min_pixel_value_q1616 + 1)/256;
    for( y=0; y<rows; y++ ) {
        for( x=0; x<cols; x++ ) {
            // initial pixel values range from 0x0000 to 0xffff (between 0.0 and 0.99998474)
            unsigned pixel_q1616 = (unsigned)*image++;
            unsigned gray_pixel_8b = ((pixel_q1616 - min_pixel_value_q1616) / scale_range) & 0xff;
            vga_plot( x, y, gray_pixel_8b );
        }
    }
}



void vga_plot(unsigned x, unsigned y, unsigned colour)
{
    *vga = colour + (x << 16) + (y << 24);
}


int main()
{
    *hex = 0x3f; /* display - */

    volatile int *l1_b = nn;                    /* layer 1 bias */
    volatile int *l1_w = l1_b + L1_OUT;         /* layer 1 weights */
    volatile int *l2_b = l1_w + L1_IN * L1_OUT; /* layer 2 bias */
    volatile int *l2_w = l2_b + L2_OUT;         /* layer 2 weights */
    volatile int *l3_b = l2_w + L2_IN * L2_OUT; /* layer 3 bias */
    volatile int *l3_w = l3_b + L3_OUT;         /* layer 3 weights */

    int result;

    // display input image on VGA screen
    // expect input pixels to be in the range [0x0000,0xFFFF]
    //display_image( input, 28, 28, 0, 0xFFFF );

    // apply_layer_dot() computes the dot product for a row
    // all data stays in SDRAM

    apply_layer_dot( L1_IN, L1_OUT, l1_b, l1_w, 1, input,  l1_acts );
    apply_layer_dot( L2_IN, L2_OUT, l2_b, l2_w, 1, l1_acts, l2_acts );
    apply_layer_dot( L3_IN, L3_OUT, l3_b, l3_w, 0, l2_acts, l3_acts );
    result = max_index( L3_OUT, l3_acts );

 

    * ((volatile unsigned*)0x00001010) = hex7seg( result );
    return 0;
}
