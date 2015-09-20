               ******************************
                WELCOME TO RESOURCE WORKSHOP
               ******************************

This README file contains important information about 
RESOURCE WORKSHOP (RW).  For the latest information
about RW, read this entire file.

*****************
TABLE OF CONTENTS
*****************
1.  How to Get Assistance
          -- Sources of information
2.  Installation
          -- Installing from a Network
3.  Using non-Delphi Resource Files in a Delphi Project

*********************************************
1. HOW TO GET ASSISTANCE
*********************************************
If you have any problems, please read this file and check the 
on-line help. If you still have a question and need assistance,
help is available from the following sources:

  1. For instant on-line access to the Borland CompuServe forums
     with their libraries of technical information and answers
     to common questions, type

        GO BCPPWIN     - for questions pertaining to the
                         operation of Resource Workshop

        GO DELPHI      - for questions pertaining to Delphi or Pascal

     If you are not a member of CompuServe, see the enclosed
     special offer, and write for full details on how to receive
     a free IntroPak containing a $15 credit toward your first
     month's on-line charges.

  2. Borland offers a wide variety of Technical Support plans
     providing a range of assistance from installation and general
     usage to language syntax, programming, and debugging help. For
     information about these support programs, call 1-800-523-7070.

  3. Borland's TECHFAX service. Call (800) 822-4269 for a FAX
     catalog of technical document entries.

  4. Borland DLBBS. Dial (408) 431-5096 (up to 9600 baud, 8-N-1)
     for a host of free technical documents and example programs.

  5. For immediate assistance with everything from configuring your
     Borland language product to programming or debugging, call our
     Advisor Lines ($2/minute, first minute free):

       C++ Advisor Lines
            * Windows / RW:     1-900-555-1002 or 1-800-782-5558 (MC/Visa)

       Delphi Advisor Line:     1-900-555-1015 or 1-800-330-3372 (MC/Visa)

  6. For questions relating to product installation only, call our
     Up & Running Lines:

       * C++ Up & Running       1-408-461-9133

       * Delphi Up & Running    1-408-461-9195

*********************************************
2. INSTALLATION 
*********************************************

For the latest information and advice about
installation, see the INSTALL.TXT file.

1. Installing from a network

If you launch SETUP.EXE from a network directory, Setup 
will not be able to display INSTALL.TXT for you.  You 
can find INSTALL.TXT on floppy disk #1, and Setup will
still copy it to your installed directory.

******************************************************
3. USING NON-DELPHI RESOURCE FILES IN A DELPHI PROJECT
******************************************************

Resource Workshop creates resource files with extensions
such as RES, RC, BMP, and ICO.  You can use these files in
your Delphi project.  They need not reside in the project
directory.  When you correctly specify such files in a
project, Delphi integrates them when you save or compile
the project. Some of these files might be common to
multiple projects. Some common examples of non-Delphi files
used in Delphi projects are:

Image files	
    The bitmaps (.BMP, .WMF files) that you use in TImage-type
    components, or as glyphs on TBitBtn components, can reside
    anywhere on your system. When specified as properties of
    these graphical components, Delphi takes a "snapshot" of
    the disk file and stores this in the binary form (.DFM)
    file.  They are eventually compiled into the project
    executable file.

Icon files	
    The icons (.ICO files) that you specify in the Icon property
    of forms and in the Project Options dialog box can also
    reside anywhere. They are integrated into the project in the
    same way as bitmap image files. .BMP and .ICO files can also
    be created with the Delphi Image editor, or you can choose
    from the bitmaps and icons available in the Delphi Image
    Library.

Menu files
    Delphi supports menus built with other applications, so
    long as they are in the standard Windows resource (.RC)
    file format. You can import such menus directly into your
    Delphi project, saving you the time and effort of
    rebuilding menus that you created elsewhere.

    To load an existing .RC menu file,

    1.	In the Menu Designer, place the cursor where you
         want the menu to appear. The imported menu can be part
         of a menu you are designing, or an entire menu in itself.

    2.	From the Menu Designer SpeedMenu, choose Insert From
         Resource. The Insert Menu From Resource dialog box appears.

    3.	In the dialog box, select the resource file you want to 
         load, and choose OK.  The menu appears in the Menu Designer 
         window.

    Note:  If your resource file contains more than one
           menu, you first need to save each menu as a separate
           resource file before importing it.

Compiled resource files (.RES)
    Use the Resource file directive {$R filename} to
    include a .RES file in an application or library.

    The default extension for filename is .RES. It must be a
    Windows resource file.  The resource file must reside in 
    the same directory as the unit source file or DCU.

    When used in a unit, the resource file name is simply
    recorded in the resulting unit file; no checks are made to
    ensure that the file exists at compile time.

    When an application or library is linked, the resource files
    specified in all units and in the program or library itself
    are processed and each resource in each resource file is
    copied to the .EXE or .DLL file being produced.

    Note: This directive allows multiple .RES files per unit.
    There is no compile-time confirmation of the contents of a
    .RES file, or whether it is a valid .RES file (whether it
    exists). Files listed with the $R directive must be present
    at link time, or you will receive the error message "File
    not found (<filename>.RES)." 
