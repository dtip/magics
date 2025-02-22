C (C) Copyright 1996-2016 ECMWF.
C 
C This software is licensed under the terms of the Apache Licence Version 2.0
C which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
C In applying this licence, ECMWF does not waive the privileges and immunities 
C granted to it by virtue of its status as an intergovernmental organisation nor
C does it submit to any jurisdiction.
C

          PROGRAM TEXT01
*
*     This Program Demonstrates MAGICS Text Writing Capabilities.
*
*     OPEN MAGICS
*
      CALL POPEN
      CALL PARSE_COMMAND_LINE ('text01')
      
      CALL PSETC ('TEXT_INSTRUCTION_SHIFT_CHARACTER', '\\')
*
*     Define Plot Layout.  Note the Setting up of SUPER_PAGE and PAGE
*     Sizes to Enable Two Pages to Fit into the SUPER_PAGE.  The Frame
*     around the SUBPAGE is Turned Off.
*     ----------------------------------------------------------------
      CALL PSETR ('SUPER_PAGE_Y_LENGTH',29.7)
      CALL PSETR ('SUPER_PAGE_X_LENGTH',21.0)
      CALL PSETR ('PAGE_X_LENGTH',21.0)
      CALL PSETR ('PAGE_Y_LENGTH',14.35)
      CALL PSETR ('PAGE_Y_GAP',1.0)
      CALL PSETC ('PLOT_START','TOP')
      CALL PSETC ('SUBPAGE_FRAME','OFF')
*
*     Position the Text Box
*     ---------------------
      CALL PSETC ('TEXT_MODE','POSITIONAL')
      CALL PSETR ('TEXT_BOX_X_POSITION',3.5)
      CALL PSETR ('TEXT_BOX_Y_POSITION',6.0)
      CALL PSETR ('TEXT_BOX_X_LENGTH', 14.0)
      CALL PSETR ('TEXT_BOX_Y_LENGTH',4.0)
*
*     Write text on Pages One and Two of each SUPER_PAGE
*     ---------------------------------------------------
      CALL TEXT01_ONE
      CALL PNEW('PAGE')
      CALL TEXT01_TWO
      CALL PNEW ('PAGE')
      CALL TEXT01_THREE
      
      CALL PNEW ('PAGE')
      CALL TEXT01_FOUR
      CALL PNEW ('PAGE')
      CALL TEXT01_FIVE
      CALL PNEW ('PAGE')
      CALL TEXT01_SIX
      CALL PNEW ('PAGE')
      CALL TEXT01_SEVEN
      CALL PNEW ('PAGE')
      CALL TEXT01_EIGHT
      CALL PNEW ('PAGE')
      CALL TEXT01_NINE
      CALL PNEW ('PAGE')
      CALL TEXT01_TEN
      CALL PNEW ('PAGE')
      CALL TEXT01_ELEVEN
      CALL PNEW ('PAGE')
      CALL TEXT01_TWELVE
      CALL PNEW ('PAGE')
      CALL TEXT01_THIRTEEN
      CALL PNEW('PAGE')
      CALL TEXT01_FOURTEEN
      CALL PNEW ('PAGE')
*
*     Close MAGICS
*     ------------
      CALL PCLOSE
      END
      SUBROUTINE TEXT01_ONE
*
*     Write Two Lines of Text in a Text Box. Text MODE is POSITIONAL
*     --------------------------------------------------------------
      CALL PSETI ('TEXT_LINE_COUNT',2)
      CALL PSETC ('TEXT_LINE_1','THIS IS THE FIRST BOX OF TEXT')
      CALL PSETC ('TEXT_LINE_2','TEXT MODE IS POSITIONAL')
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_TWO
*
*     Write a text Block with 4 Lines and Build the Block using
*     TEXT_CHARACTER, TEXT_INTEGER
*     ---------------------------------------------------------
      CALL PSETI ('TEXT_LINE_COUNT',4)
      CALL PSETI ('TEXT_INTEGER_1',4)
      CALL PSETC ('TEXT_CHARACTER_1','THIS IS THE SECOND BOX OF TEXT')
*
      CALL PSETC ('TEXT_CHARACTER_2',
     1            'THE BLOCK OF TEXT IS BUILT UP USING ' //
     2            '''TEXT_CHARACTER''')
*
      CALL PSETC ('TEXT_CHARACTER_3','TEXT CONSISTS OF')
      CALL PSETC ('TEXT_CHARACTER_4',
     1            'OBSERVE HOW TO USE TEXT_PARAMETER_ESCAPE_CHARACTER ')
*
      CALL PSETC ('TEXT_LINE_1','@TEXT_CHARACTER_1@')
      CALL PSETC ('TEXT_LINE_2','@TEXT_CHARACTER_2@')
      CALL PSETC ('TEXT_LINE_3','@TEXT_CHARACTER_3@ '//
     1            '@TEXT_INTEGER_1@ LINES IN A BLOCK')
*
      CALL PSETC ('TEXT_LINE_4','@TEXT_CHARACTER_4@')
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_THREE
*
*     Write a Text Block with Different Line Ratio
*     --------------------------------------------
      CALL PSETI ('TEXT_LINE_COUNT',4)
      CALL PSETR ('TEXT_REFERENCE_CHARACTER_HEIGHT',0.6)
      CALL PSETR ('TEXT_LINE_HEIGHT_RATIO_2',0.5)
      CALL PSETC ('TEXT_COLOUR','RED')
      CALL PSETC ('TEXT_LINE_1','THIS TEXT CHARACTER HEIGHT IS 6 >MM')
      CALL PSETC ('TEXT_LINE_2',
     X            'THE HEIGHT OF THIS TEXT IS 50% LESS THAN FIRST ONE')
*
      CALL PSETC ('TEXT_LINE_3','THE TEXT_LINE_SPACE RATIO IS 1.5')
      CALL PSETC ('TEXT_LINE_4','TEXT COLOUR IS RED')
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_FOUR
*
*     Write a Block of text with Different Height and Space Ratios
*     ------------------------------------------------------------
      CALL PSETR ('TEXT_LINE_HEIGHT_RATIO_3',0.35)
      CALL PSETR ('TEXT_LINE_SPACE_RATIO',2.0)
      CALL PSETC ('TEXT_BORDER','ON')
      CALL PSETI ('TEXT_BORDER_THICKNESS',2)
      CALL PSETC ('TEXT_COLOUR','BLUE')
      CALL PSETI ('TEXT_LINE_COUNT',3)
      CALL PSETC ('TEXT_LINE_1','TEXT BORDER IS NOW ON')
      CALL PSETC ('TEXT_LINE_2','TEXT_LINE_SPACE_RATIO IS 2')
      CALL PSETC ('TEXT_LINE_3',
     1            'THIS TEXT IS 0.35 TIMES SMALLER THAN THE FIRST ONE')
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_FIVE
*
*     Write Left Justified Block of Text using Instruction String
*     Facility
*     -----------------------------------------------------------
      CALL PSETI ('TEXT_LINE_COUNT',3)
      CALL PRESET ('TEXT_LINE_HEIGHT_RATIO_2')
      CALL PRESET ('TEXT_LINE_HEIGHT_RATIO_3')
      CALL PSETR ('TEXT_LINE_SPACE_RATIO',3.0)
      CALL PSETC ('TEXT_BORDER','OFF')
      CALL PSETC ('TEXT_JUSTIFICATION','LEFT')
      CALL PSETC ('TEXT_CHARACTER_1','This Text is Written ')
      CALL PSETC ('TEXT_CHARACTER_2',
     1            'in UPPER CASE and in lower case')
*
      CALL PSETC ('TEXT_LINE_1',
     1            '@TEXT_CHARACTER_1@  @TEXT_CHARACTER_2@')
*
      CALL PSETC ('TEXT_LINE_2',
     1            'THIS \QLH\TEXT\QLR\ IS CREATED \HG0.5\USING ' //
     2            '\HG1.0\>INSTRUCTION STRINGS')
*
      CALL PSETC ('TEXT_LINE_3',
     1           '\HG6.0\M\HG5.0\A\HG4.0\G\HG3.0\I\HG2.0\C\HG1.0\S')
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_SIX
*
*     Write Mathematical Formula using Instruction Strings
*     ----------------------------------------------------
      CALL PSETI ('TEXT_LINE_COUNT',2)
      CALL PSETR ('TEXT_LINE_SPACE_RATIO',2.3)
      CALL PSETC ('TEXT_JUSTIFICATION','CENTRE')
      CALL PSETC ('TEXT_LINE_1','TWO WAYS TO WRITE A DEGREE SYMBOL')
*     CALL PSETC ('TEXT_CHARACTER_1','\HG0.4;EL0.6\O\HGR;ELR\')
      CALL PSETC ('TEXT_CHARACTER_1','#260')
      CALL PSETC ('TEXT_CHARACTER_2','\SP\O\SPR')
* WAS CALL PSETC ('TEXT_CHARACTER_2','\SP\O\SPR\')
*
      CALL PSETC ('TEXT_LINE_2',
     1            '56@TEXT_CHARACTER_1@N,42@TEXT_CHARACTER_1@W TO ' //
     2            '38@TEXT_CHARACTER_2@N,28@TEXT_CHARACTER_2@W')
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_SEVEN
*
*     Write a Text Block with Different Colours
*     -----------------------------------------
      CALL PSETR ('TEXT_REFERENCE_CHARACTER_HEIGHT',0.8)
      CALL PSETI ('TEXT_LINE_COUNT',3)
*
      CALL PSETC ('TEXT_LINE_1','T>HIS EXT ONTAINS')
      CALL PSETC ('TEXT_LINE_2',
     1            '\CLRED\RED \CLYELLOW\YELLOW \CLCYAN\CYAN ' //
     2            '\CLBLUE\BLUE \CLBLACK\BLACK')
      CALL PSETC ('TEXT_LINE_3','C>OLOURS')
*
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_EIGHT
*
*     Write one Normally Spaced Text Line and Three
*     Monospaced Text Lines
*     ---------------------------------------------
      CALL PSETI ('TEXT_LINE_COUNT',4)
      CALL PSETC ('TEXT_CHARACTER_1','T>HIS EXT IS ONOSPACED')
      CALL PSETC ('TEXT_LINE_1','T>HIS EXT IS ORMAL')
      CALL PSETC ('TEXT_LINE_2','\CW0.7\@TEXT_CHARACTER_1@')
      CALL PSETC ('TEXT_LINE_3','\CW1.0\@TEXT_CHARACTER_1@')
      CALL PSETC ('TEXT_LINE_4','\CW1.5\@TEXT_CHARACTER_1@')
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_NINE
*
*     Write a Block of Text with Different Text Quality
*     -------------------------------------------------
      CALL PSETI ('TEXT_LINE_COUNT',3)
      CALL PSETR ('TEXT_LINE_SPACE_RATIO',2.0)
      CALL PSETC ('TEXT_JUSTIFICATION','LEFT')
      CALL PSETC ('TEXT_QUALITY','HIGH')
      CALL PSETC ('TEXT_LINE_1','TEXT QUALITY IS HIGH')
      CALL PSETC ('TEXT_LINE_2','\QLM\TEXT QUALITY IS  MEDIUM')
      CALL PSETC ('TEXT_LINE_3','\QLL\TEXT QUALITY IS LOW')
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_TEN
*
*     Write a Block of Text Demonstrating Underlining
*     -----------------------------------------------
      CALL PSETR ('TEXT_BOX_Y_LENGTH',5.5)
      CALL PSETI ('TEXT_LINE_COUNT',3)
      CALL PSETC ('TEXT_QUALITY','MEDIUM')
      CALL PSETC ('TEXT_JUSTIFICATION','CENTRE')
      CALL PSETC ('TEXT_LINE_1','\UL1\THIS LINE IS UNDERLINED')
      CALL PSETC ('TEXT_LINE_2',
     1            'ONLY \UL1\THESE WORDS\ULR\ ARE UNDERLINED')
      CALL PSETC ('TEXT_LINE_3',
     1            'SOME WORDS ARE \UL2\VERY\ULR\ IMPORTANT')
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_ELEVEN
*
*     Write a Block of text Demonstrating Subscripts and Superscripts
*     ---------------------------------------------------------------
      CALL PSETI ('TEXT_LINE_COUNT',2)
      CALL PSETC ('TEXT_LINE_1','Subscripts and Superscripts')
*
      CALL PSETC ('TEXT_LINE_2','X\SB\n\SBR\ = nX\SP\n')
*
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_TWELVE
*
*     Write a Block of text Containing Simple Formulae
*     ------------------------------------------------
      CALL PSETI ('TEXT_LINE_COUNT',8)
      CALL PSETR ('TEXT_REFERENCE_CHARACTER_HEIGHT',0.7)
      CALL PSETR ('TEXT_LINE_SPACE_RATIO',1.3)
*
      CALL PSETC ('TEXT_LINE_1','Simple Formulae')
      CALL PSETC ('TEXT_LINE_2',' ')
      CALL PSETC ('TEXT_LINE_3',
     -            '\UL1\Du\ULR\ \UL2\ \ULR\ \UL1\ (k-l)tgu')
      CALL PSETC ('TEXT_LINE_4','Dt   l + ktg\HG0.3;EL0.7\2\HGR;ELR\u')
      CALL PSETC ('TEXT_LINE_5',' ')
      CALL PSETC ('TEXT_LINE_6','\CW0.8\Where: u = \CWR\lr - ke')
      CALL PSETC ('TEXT_LINE_7',' ')
      CALL PSETC ('TEXT_LINE_8','\CW0.8\       t = \CWR\klr + e')
      CALL PTEXT
*
      RETURN
      END
      SUBROUTINE TEXT01_THIRTEEN
*
*     Write a Block of text Demonstrating Different Languages
*     -------------------------------------------------------
      CALL PSETI ('TEXT_LINE_COUNT',8)
      CALL PSETR ('TEXT_REFERENCE_CHARACTER_HEIGHT',0.7)
      CALL PSETR ('TEXT_LINE_SPACE_RATIO',1.3)
*
      CALL PSETC ('TEXT_LINE_1','Exended Fonts')
      CALL PSETC ('TEXT_LINE_2',' ')
      CALL PSETC ('TEXT_LINE_3','L#346ngde Grad 20#260 #330st')
      CALL PSETC ('TEXT_LINE_4','Longitude 20 degrees East')
      CALL PSETC ('TEXT_LINE_5',' ')
      CALL PSETC ('TEXT_LINE_6','Danish:#306#330#305#346#370#345')
      CALL PSETC ('TEXT_LINE_7',' ')
      CALL PSETC ('TEXT_LINE_8','French:#311#310#312#351#350#352')

      CALL PTEXT

      RETURN
      END
      SUBROUTINE TEXT01_FOURTEEN
*
*     Example of Automatic Text Plotting from GRIB Code
*     -------------------------------------------------
      CALL PSETC ('TEXT_MODE','TITLE')
      CALL PSETC ('SUBPAGE_FRAME','ON')
      CALL PSETC ('GRIB_INPUT_TYPE','FILE')
      CALL PSETC ('GRIB_INPUT_FILE_NAME','data/z500.grb')
      CALL PGRIB
      CALL PCONT
      CALL PTEXT

      RETURN
      END



C --------------------------------------------------------------------
C     PARSE_COMMAND_LINE
C     Checks the command-line for any arguments.
C     Arguments can come in pairs. Currently supported arguments are:
C     PROJECTION 
C     DEVICE 
C     e.g. Run the program with:
C      PROJECTION POLAR_STEREOGRAPHIC
C      PROJECTION CYLINDRICAL   DEVICE SVG
C --------------------------------------------------------------------

      SUBROUTINE PARSE_COMMAND_LINE (OUTROOTNAME)

      CHARACTER*32 ARG
      CHARACTER*64 ID_TEXT
      CHARACTER*32 PROJECTION
      CHARACTER*32 DEVICE
      CHARACTER*48 EXENAME
      CHARACTER*8  MINIMAL
      CHARACTER*8  SEPARATOR
      CHARACTER*64 OUTNAME
      CHARACTER*(*) OUTROOTNAME

      CHARACTER*16 FORMATS_PS_GIF
      DIMENSION    FORMATS_PS_GIF(2)
      DATA         FORMATS_PS_GIF /'PS', 'GIF_ANIMATION'/

      CHARACTER*16 FORMATS_PS_GIF_PDF
      DIMENSION    FORMATS_PS_GIF_PDF(3)
      DATA         FORMATS_PS_GIF_PDF /'PS', 'GIF', 'PDF'/

      INTEGER NUM_ARGS
      INTEGER DEVICE_SET

      DEVICE_SET = 0

      ID_TEXT = ''

      NUM_ARGS = IARGC()

      I = 1

20    IF (I.LE.NUM_ARGS) THEN
          CALL GETARG ( I, ARG ) 
          

C         Set the projection?

          IF (ARG.EQ.'PROJECTION') THEN
              I = I + 1 
              CALL GETARG ( I, PROJECTION ) 
              CALL PSETC ('SUBPAGE_MAP_PROJECTION', PROJECTION)


C        Set the device?

          ELSEIF (ARG.EQ.'DEVICE') THEN
              I = I + 1 
              CALL GETARG ( I, DEVICE ) 

C             Set the output filename

              IF     (DEVICE.EQ.'PS')  THEN
                OUTNAME = OUTROOTNAME //   '.ps'
                CALL PSETC ('DEVICE',       DEVICE)
                CALL PSETC ('PS_DEVICE',   'ps_a4')
                CALL PSETC ('PS_FILE_NAME', OUTNAME)
              ELSEIF (DEVICE.EQ.'PS_NEW') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'PS')
                CALL PSETC ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'EPS') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'EPS')
                CALL PSETC ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'GIF') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'GIF_ANIMATION')
                CALL PSETC ('OUTPUT_NAME', OUTROOTNAME)
                CALL PSETI ('OUTPUT_GIF_DELAY',     150)
              ELSEIF (DEVICE.EQ.'GIF_MULTI') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'GIF')
                CALL PSETC ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'PNG') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'PNG')
                CALL PSETC ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'SVG') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'SVG')
                CALL PSETC ('OUTPUT_NAME', OUTROOTNAME)

              ELSEIF (DEVICE.EQ.'BAD') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'BAD')
                CALL PSETC ('OUTPUT_NAME', OUTROOTNAME)

              ELSEIF (DEVICE.EQ.'PS_GIF') THEN
                CALL PSET1C ('OUTPUT_FORMATS', FORMATS_PS_GIF, 2)
                CALL PSETC  ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'PS_GIF_PDF') THEN
                CALL PSET1C ('OUTPUT_FORMATS', FORMATS_PS_GIF_PDF, 3)
                CALL PSETC  ('OUTPUT_NAME', OUTROOTNAME)
              ELSE
                WRITE(*, '(A)') 'BAD DEVICE: ', DEVICE
              ENDIF
            
            DEVICE_SET = 1


C        Split the PostScript pages into separate files?

          ELSEIF (ARG.EQ.'PS_SPLIT') THEN
                CALL PSETC ('OUTPUT_PS_SPLIT',     'ON')


C        Turn on the numbering for the first page?

          ELSEIF (ARG.EQ.'FIRST_PAGE_NUMBER') THEN
                CALL PSETC ('OUTPUT_NAME_FIRST_PAGE_NUMBER', 'ON')


C         Set the minimal filename number width?

          ELSEIF (ARG.EQ.'MINIMAL') THEN
              I = I + 1 
              CALL GETARG (I, MINIMAL) 
              IF     (MINIMAL.EQ.'0')  THEN
                CALL PSETI ('OUTPUT_FILE_MINIMAL_WIDTH', 0)
              ELSEIF (MINIMAL.EQ.'1')  THEN
                CALL PSETI ('OUTPUT_FILE_MINIMAL_WIDTH', 1)
              ELSEIF (MINIMAL.EQ.'2') THEN
                CALL PSETI ('OUTPUT_FILE_MINIMAL_WIDTH', 2)
              ELSEIF (MINIMAL.EQ.'3') THEN
                CALL PSETI ('OUTPUT_FILE_MINIMAL_WIDTH', 3)
              ENDIF


C         Set the file number separator?

          ELSEIF (ARG.EQ.'SEP') THEN
              I = I + 1 
              CALL GETARG ( I, SEPARATOR ) 
              CALL PSETC ('OUTPUT_FILE_SEPARATOR', SEPARATOR)


C        Run using linear contouring?

          ELSEIF (ARG.EQ.'LINEAR') THEN
                CALL PSETC ('CONTOUR_METHOD', 'LINEAR')
                CALL PSETC ('PAGE_ID_LINE_USER_TEXT_PLOT', 'ON')
                CALL PSETC ('PAGE_ID_LINE_USER_TEXT', 'LINEAR')
          ENDIF

          I = I + 1 
          GOTO 20
      ENDIF
      


C     If no device has been set, then use PostScript by default

      IF (DEVICE_SET.EQ.0) THEN
        OUTNAME = OUTROOTNAME // '.ps'
        CALL PSETC ('PS_DEVICE',    'ps_a4')
        CALL PSETC ('PS_FILE_NAME', OUTNAME)
      ENDIF

      END



