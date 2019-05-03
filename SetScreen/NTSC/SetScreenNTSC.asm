// N64 'Bare Metal' Set Screen NTSC 16BPP 320x240 Demo by krom (Peter Lemon):
arch n64.cpu
endian msb
output "SetScreenNTSC.N64", create
fill 1052672 // Set ROM Size

origin $00000000
base $80000000 // Entry Point Of Code
include "LIB/N64.INC" // Include N64 Definitions
include "LIB/N64_HEADER.ASM" // Include 64 Byte Header & Vector Table
insert "LIB/N64_BOOTCODE.BIN" // Include 4032 Byte Boot Code

Start:
  N64_INIT() // Run N64 Initialisation Routine

  lui a0,$A440    // A0 = VI Base Register ($A4400000)
  ori t0,r0,2     // T0 = Status/Control (Pixel Size = 2: 16BPP 5/5/5/1)
  sw t0,0(a0)     // Store Status/Control To VI Status Register ($A4400000)
  lui t0,$A000    // T0 = Origin (Frame Buffer Origin In Bytes = DRAM)
  sw t0,4(a0)     // Store Origin To VI Origin Register ($A4400004)
  ori t0,r0,320   // T0 = Width (Frame Buffer Line Width In Pixels = 320)
  sw t0,8(a0)     // Store Width To VI Width Register ($A4400008)
  ori t0,r0,$200  // T0 = Vertical Interrupt (Interrupt When Current Half-Line = $200)
  sw t0,12(a0)    // Store Vertical Interrupt To VI Interrupt Register ($A440000C)
  ori t0,r0,0     // T0 = Current Vertical Line (Current Half-Line, Sampled Once Per Line = 0)
  sw t0,16(a0)    // Store Current Vertical Line To VI Current Register ($A4400010)
  li t0,$3E52239  // T0 = Video Timing (Start Of Color Burst In Pixels from H-Sync = 3, Vertical Sync Width In Half Lines = 229, Color Burst Width In Pixels = 34, Horizontal Sync Width In Pixels = 57)
  sw t0,20(a0)    // Store Video Timing To VI Burst Register ($A4400014)
  ori t0,r0,$020D // T0 = Vertical Sync (Number Of Half-Lines Per Field = 525)
  sw t0,24(a0)    // Store Vertical Sync To VI V Sync Register ($A4400018)
  ori t0,r0,$0C15 // T0 = Horizontal Sync (5-bit Leap Pattern Used For PAL only = 0, Total Duration Of A Line In 1/4 Pixel = 3093)
  sw t0,28(a0)    // Store Horizontal Sync To VI H Sync Register ($A440001C)
  li t0,$0C150C15 // T0 = Horizontal Sync Leap (Identical To H Sync = 3093, Identical To H Sync = 3093)
  sw t0,32(a0)    // Store Horizontal Sync Leap To VI Leap Register ($A4400020)
  li t0,$006C02EC // T0 = Horizontal Video (Start Of Active Video In Screen Pixels = 108, End Of Active Video In Screen Pixels = 748)
  sw t0,36(a0)    // Store Horizontal Video To VI H Start Register ($A4400024)
  li t0,$002501FF // T0 = Vertical Video (Start Of Active Video In Screen Half-Lines = 37, End Of Active Video In Screen Half-Lines = 511)
  sw t0,40(a0)    // Store Vertical Video To VI V Start Register ($A4400028)
  li t0,$000E0204 // T0 = Vertical Burst (Start Of Color Burst Enable In Half-Lines = 14, End Of Color Burst Enable In Half-Lines = 516)
  sw t0,44(a0)    // Store Vertical Burst To VI V Burst Register ($A440002C)
  ori t0,r0,$200  // T0 = X-Scale (Horizontal Subpixel Offset In 2.10 Format = 0, 1/Horizontal Scale Up Factor In 2.10 Format = 512)
  sw t0,48(a0)    // Store X-Scale To VI X Scale Register ($A4400030)
  ori t0,r0,$400  // T0 = Y-Scale (Vertical Subpixel Offset In 2.10 Format = 0, 1/Vertical Scale Up Factor In 2.10 Format = 1024)
  sw t0,52(a0)    // Store Y-Scale To VI Y Scale Register ($A4400034)

Loop:
  j Loop
  nop // Delay Slot