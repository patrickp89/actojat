 IDENTIFICATION DIVISION.
 PROGRAM-ID. SimpleIfThen.

 DATA DIVISION.
 WORKING-STORAGE SECTION.
 01 n PIC 9 VALUE 5.

 PROCEDURE DIVISION.
 MainProgram.
      IF n < 10 THEN
        DISPLAY "Yeah"
      END-IF
      STOP RUN.
