C (C) Copyright 1996-2016 ECMWF.
C 
C This software is licensed under the terms of the Apache Licence Version 2.0
C which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
C In applying this licence, ECMWF does not waive the privileges and immunities 
C granted to it by virtue of its status as an intergovernmental organisation nor
C does it submit to any jurisdiction.
C

      PROGRAM SYMB02

*
*     SYMBOL PLOTTING EXAMPLE
*   
*     USING SYMBOL PLOTTING TO PLOT THE NAMES OF THE CAPITAL
*     CITIES OF EUROPE AND THEIR POSITIONS (WITH MARKERS)
*
      CALL POPEN 
      CALL PARSE_COMMAND_LINE ('symb02')
*
*     PLOT POLAR MAP OF EUROPE
*     ------------------------
      CALL PSETC('SYMBOL_POSITION_MODE','GEOGRAPHIC')
      CALL PSETC('SUBPAGE_MAP_PROJECTION','POLAR_STEREOGRAPHIC')
      CALL PSETC('SUBPAGE_MAP_AREA_DEFINITION','CENTRE')
      CALL PSETR('SUBPAGE_MAP_CENTRE_LATITUDE',50.0)     
      CALL PSETR('SUBPAGE_MAP_CENTRE_LONGITUDE',10.0)     
      CALL PSETR('SUBPAGE_MAP_VERTICAL_LONGITUDE',0.0)     
      CALL PSETR('SUBPAGE_MAP_SCALE',22.E6)     
      CALL PSETC('SYMBOL_QUALITY','HIGH')
      CALL PSETC('MAP_COASTLINE_COLOUR','BLACK')
      CALL PSETC('MAP_COASTLINE_RESOLUTION','HIGH')
      CALL PSETC('MAP_COASTLINE_LAND_SHADE','ON')
      CALL PSETC('MAP_COASTLINE_LAND_SHADE_COLOUR','CREAM')
      CALL PSETC('MAP_GRID_COLOUR','BLACK')
      CALL PCOAST
*
*     PLOT THE NAMES
*     --------------
      CALL SYMB02_ONE
*
*     PLOT THE POSITIONS
*     ------------------
      CALL SYMB02_TWO
      CALL PSETC('TEXT_JUSTIFICATION','CENTRE')
      CALL PSETC('TEXT_LINE_1',
     x 'MAGICS Symbol plotting using TEXT and MARKER options')
      CALL PSETI('TEXT_LINE_COUNT',1)
      CALL PTEXT
      CALL PCLOSE
      STOP
      END
      SUBROUTINE SYMB02_ONE
*
*     PLOT CITY NAMES
*     ---------------
      CHARACTER*32 TEX
      DIMENSION X(29),Y(29),TEX(29)
      DATA TEX/'Oslo','London','Wien','Ankara','Lisboa','Bruxelles',
     X  'Reykjavic','Madrid','Bern','Koebenhavn','Dublin',
     X   'The Hague','Athens','Paris','Helsinki','Roma','Bonn',
     X   'Stockholm',11*' '/
      DATA X/10.63,0.0,16.34,32.88,-9.13,4.53,-21.9,-3.72,7.5,
     X       12.53,-6.25,4.25,23.73,2.33,25.05,12.58,7.2,17.95,
     X       11*0.0/
      DATA Y/59.90,51.5,48.23,39.95,38.77,50.90,64.13,40.45,46.92,
     X       55.77,52.43,52.15,37.9,48.83,60.25,41.78,50.7,59.65,
     X       11*0.0/
      INUM=5
*
*     ADJUST POSITIONS OF NAMES TO AVOID CLUTTERING
*     ---------------------------------------------
      DO 100 J=1,29
         Y(J)=Y(J)+0.75
100   CONTINUE
      Y(2)=y(2)+0.25
      Y(12)=y(12)+0.25
      Y(17)=y(17)-1.25
*
*     PLOT SOME CITIES IN RED
*     -----------------------
      CALL PSETC('SYMBOL_TABLE_MODE','OFF')
      CALL PSETR('SYMBOL_HEIGHT',0.4)
      CALL PSETC('SYMBOL_TYPE','TEXT')
      CALL PSET1C('SYMBOL_INPUT_TEXT_LIST',TEX,INUM)
      CALL PSET1R('SYMBOL_INPUT_X_POSITION',X,INUM)
      CALL PSET1R('SYMBOL_INPUT_Y_POSITION',Y,INUM)
      CALL PSETC('SYMBOL_COLOUR','RED')
      CALL PSYMB
*
*     PLOT SOME CITIES IN BLUE
*     ------------------------
      CALL PSET1C('SYMBOL_INPUT_TEXT_LIST',TEX(6),INUM)
      CALL PSET1R('SYMBOL_INPUT_X_POSITION',X(6),INUM)
      CALL PSET1R('SYMBOL_INPUT_Y_POSITION',Y(6),INUM)
      CALL PSETC('SYMBOL_COLOUR','BLUE')
      CALL PSYMB
*
*     PLOT SOME CITIES IN GREEN
*     -------------------------
      CALL PSET1C('SYMBOL_INPUT_TEXT_LIST',TEX(11),INUM)
      CALL PSET1R('SYMBOL_INPUT_X_POSITION',X(11),INUM)
      CALL PSET1R('SYMBOL_INPUT_Y_POSITION',Y(11),INUM)
      CALL PSETC('SYMBOL_COLOUR','GREEN')
      CALL PSYMB
*
*     PLOT SOME CITIES IN MAGENTA
*     ---------------------------
      INUM=3
      CALL PSET1C('SYMBOL_INPUT_TEXT_LIST',TEX(16),INUM)
      CALL PSET1R('SYMBOL_INPUT_X_POSITION',X(16),INUM)
      CALL PSET1R('SYMBOL_INPUT_Y_POSITION',Y(16),INUM)
      CALL PSETC('SYMBOL_COLOUR','MAGENTA')
      CALL PSYMB
      RETURN
      END
      SUBROUTINE SYMB02_TWO
*
*     PLOT CITY POSITIONS
*     -------------------
      CHARACTER*32 XCLTAB,XTX
      DIMENSION XMNTAB(4),XMXTAB(4),XCLTAB(4),XHGTAB(4)
      DIMENSION X(29),Y(29),XNUM(29),ISYM(4)
      DATA ISYM/4*18/
      DATA XNUM/5.,5.,5.,5.,5.,15.,15.,15.,15.,15.,25.,25.,25.,
     X          25.,25.,35.,35.,35.,11*0.0/
      DATA XHGTAB/0.2,0.2,0.2,0.2/
      DATA XMNTAB/1.,11,21.,31./
      DATA XMXTAB/10.,20,30.,40./
      DATA XCLTAB/'RED','BLUE','GREEN','MAGENTA'/
      DATA X/10.63,0.0,16.34,32.88,-9.13,4.53,-21.9,-3.72,7.5,
     X       12.53,-6.25,4.25,23.73,2.33,25.05,12.58,7.2,17.95,
     X       11*0.0/
      DATA Y/59.90,51.5,48.23,39.95,38.77,50.90,64.13,40.45,46.92,
     X       55.77,52.43,52.15,37.9,48.83,60.25,41.78,50.7,59.65,
     X       11*0.0/
      INUM=18
*
*     USE 'TABLE' MODE TO PLOT DIFFERENT COLOURED SYMBOLS
*     ---------------------------------------------------
      CALL PSETC('SYMBOL_TABLE_MODE','ON')
      CALL PSET1R('SYMBOL_INPUT_X_POSITION',X,INUM)
      CALL PSET1R('SYMBOL_INPUT_Y_POSITION',Y,INUM)
      CALL PSET1R('SYMBOL_INPUT_NUMBER_LIST',XNUM,INUM)
      CALL PSETC('SYMBOL_TYPE','MARKER')
      CALL PSET1I('SYMBOL_MARKER_TABLE',ISYM,4)
      CALL PSET1R('SYMBOL_MIN_TABLE',XMNTAB,4)
      CALL PSET1R('SYMBOL_MAX_TABLE',XMXTAB,4)
      CALL PSET1C('SYMBOL_COLOUR_TABLE',XCLTAB,4)
      CALL PSET1R('SYMBOL_HEIGHT_TABLE',XHGTAB,4)
      CALL PSYMB
      RETURN
      END

C --------------------------------------------------------------------
C     PARSE_COMMAND_LINE
C     Checks the command-line for any arguments.
C     Arguments can come in pairs. Currently supported arguments are:
C     PROJECTION <CYLINDRICAL | POLAR_STEREOGRAPHIC>
C     DEVICE <PS | SVG | PNG>
C     e.g. Run the program with:
C       <progname> PROJECTION CYLINDRICAL  DEVICE SVG
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
      DATA         FORMATS_PS_GIF_PDF /'PS', 'GIF_ANIMATION', 'PDF'/

      CHARACTER*16 FORMATS_PS_GIF_SVG
      DIMENSION    FORMATS_PS_GIF_SVG(3)
      DATA         FORMATS_PS_GIF_SVG /'PS', 'GIF_ANIMATION', 'SVG'/

      CHARACTER*16 FORMATS_PS_PNG_SVG
      DIMENSION    FORMATS_PS_PNG_SVG(3)
      DATA         FORMATS_PS_PNG_SVG /'PS', 'PNG', 'SVG'/

      CHARACTER*16 FORMATS_PS_GIF_PNG_SVG
      DIMENSION    FORMATS_PS_GIF_PNG_SVG(4)
      DATA         FORMATS_PS_GIF_PNG_SVG /'PS', 'GIF_ANIMATION', 
     +                                     'PNG', 'SVG'/

      CHARACTER*16 FORMATS_ALL
      DIMENSION    FORMATS_ALL(5)
      DATA         FORMATS_ALL /'PS', 'SVG', 'PDF',
     +                          'KML', 'PNG'/

      INTEGER NUM_ARGS
      INTEGER DEVICE_SET

      DEVICE_SET = 0

      ID_TEXT = ''

      NUM_ARGS = IARGC()

      I = 1
C
C  Start GoTo
C
20    IF (I.LE.NUM_ARGS) THEN
          CALL GETARG ( I, ARG )
C
C         Set the projection?
C
          IF (ARG.EQ.'PROJECTION') THEN
              I = I + 1 
              CALL GETARG ( I, PROJECTION ) 
              CALL PSETC ('SUBPAGE_MAP_PROJECTION', PROJECTION)
C
C        Set the device?
C
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
              ELSEIF (DEVICE.EQ.'JPEG') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'JPEG')
                CALL PSETC ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'SVG') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'SVG')
                CALL PSETC ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'CSVG') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'CSVG')
                CALL PSETC ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'KML') THEN
                CALL PSETC ('OUTPUT_FORMAT',  'KML')
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
              ELSEIF (DEVICE.EQ.'PS_GIF_SVG') THEN
                CALL PSET1C ('OUTPUT_FORMATS', FORMATS_PS_GIF_SVG, 3)
                CALL PSETC  ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'PS_PNG_SVG') THEN
                CALL PSET1C ('OUTPUT_FORMATS', FORMATS_PS_PNG_SVG, 3)
                CALL PSETC  ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'PS_GIF_PNG_SVG') THEN
                CALL PSET1C ('OUTPUT_FORMATS',
     +                               FORMATS_PS_GIF_PNG_SVG, 4)
                CALL PSETC  ('OUTPUT_NAME', OUTROOTNAME)
              ELSEIF (DEVICE.EQ.'ALL') THEN
                CALL PSET1C ('OUTPUT_FORMATS', FORMATS_ALL, 5)
                CALL PSETC  ('OUTPUT_NAME', OUTROOTNAME)
              ELSE
                WRITE(*, '(A)') 'BAD DEVICE: ', DEVICE
              ENDIF
            
            DEVICE_SET = 1
C
C        Split the PostScript pages into separate files?
C
          ELSEIF (ARG.EQ.'PS_SPLIT') THEN
                CALL PSETC ('OUTPUT_PS_SPLIT',     'ON')
C
C        Turn on the numbering for the first page?
C
          ELSEIF (ARG.EQ.'FIRST_PAGE_NUMBER') THEN
                CALL PSETC ('OUTPUT_NAME_FIRST_PAGE_NUMBER', 'ON')
C
C         Set the minimal filename number width?
C
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
C
C         Set the file number separator?
C
          ELSEIF (ARG.EQ.'SEP') THEN
              I = I + 1 
              CALL GETARG ( I, SEPARATOR ) 
              CALL PSETC ('OUTPUT_FILE_SEPARATOR', SEPARATOR)
C
C        Run using linear contouring?
C
          ELSEIF (ARG.EQ.'LINEAR') THEN
                CALL PSETC ('CONTOUR_METHOD', 'LINEAR')
                CALL PSETC ('PAGE_ID_LINE_USER_TEXT_PLOT', 'ON')
                CALL PSETC ('PAGE_ID_LINE_USER_TEXT', 'LINEAR')
          ENDIF
          I = I + 1 
          GOTO 20
      ENDIF
C
C     If no device has been set, then use PostScript by default
C
      IF (DEVICE_SET.EQ.0) THEN
        OUTNAME = OUTROOTNAME // '.ps'
        CALL PSETC ('PS_DEVICE',    'ps_a4')
        CALL PSETC ('PS_FILE_NAME', OUTNAME)
      ENDIF
C
      END
