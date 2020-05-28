// begin CC BY-NC-SA-4.0 licensed code (c) 2020 Anthony Roberts

// The number of lines to add to the board
board_line_count = 38; // [1:40]

// The depth (z/mm) of each line in mm
board_line_depth = 4;

// The width (y/mm) of each line in mm
board_line_width = 3;

// The width (x/mm) of the whole board
board_width = 200;

// The depth (z/mm) of the whole board
board_depth = 6;

// The width (mm) of the frame lip that keeps the board in
frame_lip_width = 10;

// The height/thickness (mm) of the lip
frame_lip_height = 1;

// The total depth (mm) of the frame
frame_height = 15;

// The thickness (mm) of the outer edges of the frame
frame_thickness = 1.2;

// The tolerances (mm) in the frame so the board isn't too tight
frame_tolerance = 0.15;

// The tolerance (mm) in the fins on the back of the letter for attaching to the board
letter_tolerance = 0.3;

// The maximum width (mm) of the letter/character fin removal lines
textWidth = 30;

// The amount (mm) to shift the letter up by to account for the underhang on the "Q"
letterUnderhangCompensation = 8.6;

// The maximum height (mm) of the letter including fins
letter_extrusion_height = 6;

// The depth (mm) of the fins on the back of the letter
letter_depth = 3;

// The font size (pt) tp use for the letter
letter_font_size = 22;

// The stl model to export (openscad only lets you export one at a time)
stl_to_export = "Ltr_A"; //[ "Board", "Frame", "Ltr_A", "Ltr_B", "Ltr_C", "Ltr_D", "Ltr_E", "Ltr_F", "Ltr_G", "Ltr_H", "Ltr_I", "Ltr_J", "Ltr_K", "Ltr_L", "Ltr_M", "Ltr_N", "Ltr_O", "Ltr_P", "Ltr_Q", "Ltr_R", "Ltr_S", "Ltr_T", "Ltr_U", "Ltr_V", "Ltr_W", "Ltr_X", "Ltr_Y", "Ltr_Z", "Ltr_1", "Ltr_2", "Ltr_3", "Ltr_4", "Ltr_5", "Ltr_6", "Ltr_7", "Ltr_8", "Ltr_9", "Ltr_0", "Ltr_.", "Ltr_!" ]

board_length = board_line_width + (board_line_count*board_line_width*2);

if(search("Board", stl_to_export) == [0, 1, 2, 3, 4]) {
    innerBoard();
} else if(search("Frame", stl_to_export) == [0, 1, 2, 3, 4]) {
    frame();
} else if(search("Ltr", stl_to_export) == [0, 1, 2]) {
    letters(stl_to_export[len(stl_to_export) - 1]);
}

module letters(letter) {    
    difference() { 
        translate([0, letterUnderhangCompensation, 0]) {
            linear_extrude(letter_extrusion_height){
                mirror([1,0,0]) {
                    text(letter,font="Liberation Sans",size=letter_font_size);
                }
            }
        }
        
        for(i=[0:1:11]) {
            translate([-textWidth, i*(board_line_width) - letter_tolerance, letter_depth]){
                if(i%2 == 0)
                    cube([textWidth, board_line_width + letter_tolerance, letter_depth]);
            }
        }
    }
}

module frame() {
    difference() {
        // Main frame cube
        cube([board_width + (2*frame_thickness), board_length + (2*frame_thickness), frame_height]);
        
        // Inner removal cube
        translate([frame_thickness + frame_tolerance, frame_thickness + frame_tolerance, frame_lip_height]) {
            cube([board_width - 2*frame_tolerance, board_length - 2*frame_tolerance, frame_height]);
        }
            
        // Lip removal cube
        translate([frame_thickness + frame_lip_width, frame_thickness + frame_lip_width, 0]) {
            cube([board_width - 2*frame_lip_width, board_length - 2*frame_lip_width, frame_height]);
        }
    }
    
    echo(str("Frame size (WxL): ",board_width + (2*frame_thickness),"x",board_length + (2*frame_thickness)));
}

module innerBoard() {

difference() {

    // Main board cube
    cube([board_width, board_length,board_depth]);

    // Line removal cubes
    for (i=[1:1:board_line_count]) {
        translate([0, 2*(i*board_line_width) - board_line_width, board_depth-board_line_depth])
            cube([board_width, board_line_width,board_line_depth]);
        }
    }

    echo(str("Board size (WxL): ",board_width,"x",board_length));

}