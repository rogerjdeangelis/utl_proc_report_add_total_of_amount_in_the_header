Proc report add total of amount in the header

  You can use 'proc corresp'(prefered) or two 'proc reports'

  INPUT
  =====
    WORK.HAVE total obs=32                                     FLAG_
                                                               REAL_
     PRODUIT    GENERATION    PERIODE    MEASURE      VALUE    PREV

        A          2008        201710    nborder        810      R
        A          2008        201710    sales       801000      R
        A          2008        201709    nborder        809      R
        A          2008        201709    sales        80900      R
        A          2009        201710    nborder        910      R
        A          2009        201710    sales       901000      R
        A          2009        201709    nborder        909      R
      ...

  WORKING CODE (most of it)
  =========================
     Ods Output Observed=havSum;
     Proc Corresp Data=have Observed dim=1 cross=both;
        table produit generation measure, periode flag_real_prev;
        weight value;

     set havsum(where=(label='Sum'));
       array namSum  _:;
       do i=1 to dim(namSum);
         call symputx(vname(namSum[i]),put(namSum[i],dollar13.));
       end;

     proc report data=havSum(where=(label ne 'Sum')) nowd;
     cols label ( "201709" _201709___P _201709___R )
                ( "201710" _201710___P _201710___R ) SUM;
     define _201709___P / display   "P (&_201709___P)" width=16 format=dollar13.;
     define _201709___R / display   "R (&_201709___R)" width=16 format=dollar13.;
     define _201710___P / display   "P (&_201710___P)" width=16 format=dollar13.;
     define _201710___R / display   "R (&_201710___R)" width=16 format=dollar13.;
     define sum /display  format=dollar13.;
     run;quit;

  OUTPUT
  ======

                              201709                           201710
    LABEL                P ($3,470,376)   R ($347,036)   P ($34,074,416)    R ($3,407,440)        Sum

    A * 2008 * nborder         $8,092           $809            $8,102              $810        $17,813
    A * 2008 * sales         $809,002        $80,900        $8,010,002          $801,000     $9,700,904
    A * 2009 * nborder         $9,092           $909            $9,102              $910        $20,013
    A * 2009 * sales         $909,002        $90,900        $9,010,002          $901,000    $10,910,904

    B * 2008 * nborder         $8,092           $809            $8,102              $810        $17,813
    B * 2008 * sales         $809,002        $80,900        $8,010,002          $801,000     $9,700,904
    B * 2009 * nborder         $9,092           $909            $9,102              $910        $20,013
    B * 2009 * sales         $909,002        $90,900        $9,010,002          $901,000    $10,910,904

see
https://goo.gl/2TsbF
https://communities.sas.com/t5/SAS-Procedures/proc-report-add-total-of-amount-in-the-header/m-p/411925

*                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

data have ;
input produit $ generation periode  measure $ value FLAG_REAL_PREV $ ;
cards4 ;
A 2008 201710 nborder 810 R
A 2008 201710 sales 801000 R
A 2008 201709 nborder 809 R
A 2008 201709 sales 80900 R
A 2009 201710 nborder 910 R
A 2009 201710 sales 901000 R
A 2009 201709 nborder 909 R
A 2009 201709 sales 90900 R
A 2008 201710 nborder 8102 P
A 2008 201710 sales 8010002 P
A 2008 201709 nborder 8092 P
A 2008 201709 sales 809002 P
A 2009 201710 nborder 9102 P
A 2009 201710 sales 9010002 P
A 2009 201709 nborder 9092 P
A 2009 201709 sales 909002 P
B 2008 201710 nborder 810 R
B 2008 201710 sales 801000 R
B 2008 201709 nborder 809 R
B 2008 201709 sales 80900 R
B 2009 201710 nborder 910 R
B 2009 201710 sales 901000 R
B 2009 201709 nborder 909 R
B 2009 201709 sales 90900 R
B 2008 201710 nborder 8102 P
B 2008 201710 sales 8010002 P
B 2008 201709 nborder 8092 P
B 2008 201709 sales 809002 P
B 2009 201710 nborder 9102 P
B 2009 201710 sales 9010002 P
B 2009 201709 nborder 9092 P
B 2009 201709 sales 909002 P
;;;;
run;quit;

Ods Exclude All;
Ods Output Observed=havSum;
Proc Corresp Data=have
             Observed
             dim=1 cross=both;
     table produit generation measure, periode flag_real_prev;
     weight value;
run;quit;
Ods Select All;

data hdr;
  set havsum(where=(label='Sum'));
  array namSum  _:;
  do i=1 to dim(namSum);
    call symputx(vname(namSum[i]),put(namSum[i],dollar13.));
  end;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

proc report data=havSum(where=(label ne 'Sum')) nowd;
cols label
  ( "201709"
  _201709___P
  _201709___R )
  ( "201710"
  _201710___P
  _201710___R
  )
  SUM;
define _201709___P / display   "P (&_201709___P)" width=16 format=dollar13.;
define _201709___R / display   "R (&_201709___R)" width=16 format=dollar13.;
define _201710___P / display   "P (&_201710___P)" width=16 format=dollar13.;
define _201710___R / display   "R (&_201710___R)" width=16 format=dollar13.;
define sum /display  format=dollar13.;
run;quit;


