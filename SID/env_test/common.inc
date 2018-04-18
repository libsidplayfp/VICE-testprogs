
.macro assert_same_page label_
   .assert >(label_) = >(*), error, "Page crossing detected!"
.endmacro

    .export main, loop
    .export msg_testname
    .import v3_AD, v3_SR, v3_gate, v3_env
    .import hard_restart_and_blank_screen
    .import wframe
    .import sync_to_rc     ; requires env3 to be zero, assumes A=R=0
    .import fail, success


