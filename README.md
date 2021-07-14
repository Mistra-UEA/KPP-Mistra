# KPP-Mistra
latest KPP release, reviewed and customised for Mistra

Built upon KPP-v2.2.3:
https://people.cs.vt.edu/~asandu/Software/Kpp/

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  KPP - symbolic chemistry Kinetics PreProcessor
        (for version, see src/gdata.h)
        http://www.cs.vt.edu/~asandu/Software/Kpp
  KPP is distributed under GPL, the general public licence
        (http://www.gnu.org/copyleft/gpl.html)
    (C) 1995-1997, V. Damian & A. Sandu, CGRER, Univ. Iowa
    (C) 1997-2016, A. Sandu, Michigan Tech, Virginia Tech
        with contributions from:
        R. Sander, Max-Planck Institute for Chemistry, Mainz, Germany

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To get started with KPP:  Read user's manual (doc/kpp_UserManual.pdf)
------------------------

To install KPP:
---------------

1. Make sure that FLEX (public domain lexical analizer) is installed
   on your machine. Type "flex --version" to test this.

2. Note down the exact path name where the FLEX library is installed. The
   library is called:
	libfl.a or libfl.sh

3. Make sure that BISON is installed on your machine.
   Type "bison --version" to test this.

4. Define the KPP_HOME environment variable to point to the complete
   path location of KPP. If, for example, KPP is installed in $HOME/kpp:

   - with C shell (or tcsh) edit the file .cshrc (or .tcshrc) in your
     home directory and add:
        ```shell
	setenv KPP_HOME $HOME/kpp
	set path=( $path $HOME/kpp/bin )
        ```

   - with bash shell edit the file .bashrc in your home directory and add:
        ```shell
	export KPP_HOME=$HOME/kpp
	export PATH=${PATH}:$HOME/kpp/bin
        ```

   - Execute 'source ~/.cshrc' (or .tcshrc, or .bashrc) to make sure these
     changes are in effect.

5. In KPP_HOME directory edit:
	Makefile.defs
   and follow the instructions included to specify the compiler,
   the location of the FLEX library, etc.

6. In KPP_HOME directory build the sources using:
	make

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To clean the KPP installation:
------------------------------

1. Delete the KPP object files with:
	make clean

2. Delete the whole distribution (including the KPP binaries) with:
	make distclean