%let pgm=utl-indirect-addressing-indexed-lookup-in-sas-r-and-python-sql-multi-language;

Indirect addressing indexed lookup in sql sas r python multi language

      SOLUTIONS

         1 sas sql
         2 r sql
         3 python sql

Trivial in sas datastep

github
https://tinyurl.com/yts2tdau
https://github.com/rogerjdeangelis/utl-indirect-addressing-indexed-lookup-in-sas-r-and-python-sql-multi-language

related to
https://tinyurl.com/yhjvawb8
https://stackoverflow.com/questions/79199863/reorder-numpy-array-by-given-index-list

Inportant point several versions od SQL have built in row_number, SQLLITE has rowid.
This assures a primary key

You could make rowid and unique index and the lookup would be very fast?

SOAPBOX ON
I find an idex of 0 to be a little strange. An index of 0 can be thought of
as no index. Zero is not consistent with bolean logic.
Not son4sistent with SQL?
SOAPBOX OFF

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  INPUT (2 Tables)    |       PROCESS                      |  OUTPUT                                                    */
/*                      |     (INDEXED LOOKUP)               |                                                            */
/*                      |                                    |                                                            */
/*  SD1.IDX  SD1.VAL    |        IDX    VAL                  |                                                            */
/*                      |        ---  ---------              |                                                            */
/*   IDX       VAL      |        IDX  ROWID VAL              |  ROWID  WANT                                               */
/*                      |        ---  ---------              |                                                            */
/*   2          13      |               1    13              |     2    19                                                */
/*   4          19      |         2-->  2    19              |     4     6                                                */
/*   5          31      |               3    31              |     5    21                                                */
/*   7           6      |         4-->  4     6              |     7    98                                                */
/*              21      |         5-->  5    21              |                                                            */
/*              45      |               6    45              |                                                            */
/*              98      |         7-->  7    98              |                                                            */
/*             131      |               8   131              |                                                            */
/*              11      |               9    11              |                                                            */
/*                      |                                    |                                                            */
/*                      |------------------------------------|                                                            */
/*                      |  SAS                               |                                                            */
/*                      |                                    |                                                            */
/*                      |  select                            |                                                            */
/*                      |     l.idx                          |                                                            */
/*                      |    ,r.val                          |                                                            */
/*                      |    ,r.position                     |                                                            */
/*                      |  from                              |                                                            */
/*                      |    sd1.idx as l left join          |                                                            */
/*                      |      (select                       |                                                            */
/*                      |          monotonic() as position   |                                                            */
/*                      |         ,val                       |                                                            */
/*                      |       from                         |                                                            */
/*                      |          sd1.lst                   |                                                            */
/*                      |      )  as r                       |                                                            */
/*                      |   on                               |                                                            */
/*                      |       l.idx = r.position           |                                                            */
/*                      |                                    |                                                            */
/*                      |------------------------------------|                                                            */
/*                      |  R AND PYTHON                      |                                                            */
/*                      |                                    |                                                            */
/*                      |   select                           |                                                            */
/*                      |      l.idx                         |                                                            */
/*                      |     ,r.val                         |                                                            */
/*                      |     ,r.rowid                       |                                                            */
/*                      |   from                             |                                                            */
/*                      |     idx as l left join             |                                                            */
/*                      |       (select                      |                                                            */
/*                      |           rowid                    |                                                            */
/*                      |          ,val                      |                                                            */
/*                      |        from                        |                                                            */
/*                      |           lst                      |                                                            */
/*                      |       )  as r                      |                                                            */
/*                      |    on                              |                                                            */
/*                      |        l.idx = r.rowid             |                                                            */
/*                      |                                    |                                                            */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/


options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.idx;
 input idx;
cards4;
2
4
5
7
;;;;
run;quit;

data sd1.lst;
 input val;
cards4;
13
19
31
6
21
45
98
131
11
;;;;
run;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/*  INPUT (2 Tables)                                                                                                      */
/*                                                                                                                        */
/*                                                                                                                        */
/*  SD1.IDX  SD1.VAL                                                                                                      */
/*  =======  =======                                                                                                      */
/*   IDX       VAL                                                                                                        */
/*                                                                                                                        */
/*   2          13                                                                                                        */
/*   4          19                                                                                                        */
/*   5          31                                                                                                        */
/*   7           6                                                                                                        */
/*              21                                                                                                        */
/*              45                                                                                                        */
/*              98                                                                                                        */
/*             131                                                                                                        */
/*              11                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                             _
/ |  ___  __ _ ___   ___  __ _| |
| | / __|/ _` / __| / __|/ _` | |
| | \__ \ (_| \__ \ \__ \ (_| | |
|_| |___/\__,_|___/ |___/\__, |_|
                            |_|
*/

proc sql;
  create
     table want as
  select
     l.idx
    ,r.val
    ,r.position
  from
    sd1.idx as l left join
      (select
          monotonic() as position
         ,val
       from
          sd1.lst
      )  as r
   on
       l.idx = r.position

;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* IDX    VAL    POSITION                                                                                                 */
/*                                                                                                                        */
/*  2      13        1                                                                                                    */
/*  4      31        3                                                                                                    */
/*  5       6        4                                                                                                    */
/*  7      45        6                                                                                                    */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
idx<-read_sas("d:/sd1/idx.sas7bdat")
lst<-read_sas("d:/sd1/lst.sas7bdat")
want<-sqldf('
  select
     l.idx
    ,r.val
    ,r.rowid
  from
    idx as l left join
      (select
          rowid
         ,val
       from
          lst
      )  as r
   on
       l.idx = r.rowid
')
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                       |                                                                                                */
/* R                     | SAS                                                                                            */
/*                       |                                                                                                */
/*  IDX    VAL    ROWID  |   ROWNAMES    IDX    VAL    ROWID                                                              */
/*                       |                                                                                                */
/*   2      13      1    |       1        2      13      1                                                                */
/*   4      31      3    |       2        4      31      3                                                                */
/*   5       6      4    |       3        5       6      4                                                                */
/*   7      45      6    |       4        7      45      6                                                                */
/*                       |                                                                                                */
/**************************************************************************************************************************/

/*____               _   _                             _
|___ /    ___  _   _| |_| |__   ___  _ __    ___  __ _| |
  |_ \   / _ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
 ___) | | (_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
|____/   \___/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
               |___/                                |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
idx,meta = ps.read_sas7bdat('d:/sd1/idx.sas7bdat');
lst,meta = ps.read_sas7bdat('d:/sd1/lst.sas7bdat');
want=pdsql('''
  select
     l.idx
    ,r.val
    ,r.rowid
  from
    idx as l left join
      (select
          rowid
         ,val
       from
          lst
      )  as r
   on
       l.idx = r.rowid + 1
   ''');
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;

/**************************************************************************************************************************/
/*                       |                                                                                                */
/* R                     |  SAS                                                                                           */
/*                       |                                                                                                */
/*     IDX   val  rowid  |  IDX    VAL    ROWID                                                                           */
/*                       |                                                                                                */
/*  0  2.0  13.0      1  |   2      13      1                                                                             */
/*  1  4.0  31.0      3  |   4      31      3                                                                             */
/*  2  5.0   6.0      4  |   5       6      4                                                                             */
/*  3  7.0  45.0      6  |   7      45      6                                                                             */
/*                       |                                                                                                */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/































































test_vals = np.array([13, 19, 31, 6, 21, 45, 98, 131, 11])
array([21, 31, 131, 45])
Related to
 https://stackoverflow.com/questions/79199863/reorder-numpy-array-by-given-index-list


options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.idx;
 input idx;
cards4;
2
4
5
7
;;;;
run;quit;

data sd1.lst;
 input val;
cards4;
13
19
31
6
21
45
98
131
11
;;;;
run;quit;


proc sql;
  create
     table want as
  select
     l.idx
    ,r.val
    ,r.position
  from
    sd1.idx as l left join
      (select
          monotonic() as position
         ,val
       from
          sd1.lst
      )  as r
   on
       l.idx = r.position

;quit;

IDX    VAL    POSITION

 2      13        1
 4      31        3
 5       6        4
 7      45        6









proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
idx<-read_sas("d:/sd1/idx.sas7bdat")
lst<-read_sas("d:/sd1/lst.sas7bdat")
want<-sqldf('
  select
     l.idx
    ,r.val
    ,r.rowid
  from
    idx as l left join
      (select
          rowid
         ,val
       from
          lst
      )  as r
   on
       l.idx = r.rowid
')
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

  IDX    VAL    ROWID

   2      13      1
   4      31      3
   5       6      4
   7      45      6



 ROWNAMES    IDX    VAL    ROWID

     1        2      13      1
     2        4      31      3
     3        5       6      4
     4        7      45      6















proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read());
idx,meta = ps.read_sas7bdat('d:/sd1/idx.sas7bdat');
lst,meta = ps.read_sas7bdat('d:/sd1/lst.sas7bdat');
want=pdsql('''
  select
     l.idx
    ,r.val
    ,r.rowid
  from
    idx as l left join
      (select
          rowid
         ,val
       from
          lst
      )  as r
   on
       l.idx = r.rowid + 1
   ''');
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx;

proc print data=sd1.pywant;
run;quit;


   IDX   val  rowid
0  2.0  13.0      1
1  4.0  31.0      3
2  5.0   6.0      4
3  7.0  45.0      6


  IDX    VAL    ROWID

   2      13      1
   4      31      3
   5       6      4
   7      45      6











proc sql;
  create
     table want as
  select
     l.idx
    ,r.val
    ,r.partition
  from
    idx as l left join
      %sqlpartition(lst,by=1)
        as r
   on
       l.idx = r.position
;quit;

proc sql;
select
   monotonic() as position
  ,val
from
   lst
;quit;

proc sql;
(select row_number ,row_number - min(row_number) +1 as partition ,* from (select *, monotonic() as row_number from (select *, max(1) as delete
from lst group by 1 )) group by 1 )
;quit;

proc sql;
create
   view seq as
select
   monotonic() as position
  ,val
from
   lst
;
create
   table want as
  select
     l.idx
    ,r.val
    ,r.position
  from
    idx as l left join
       seq as r
   on
       l.idx = r.position
;quit;



test_vals = np.array([13, 19, 31, 6, 21, 45, 98, 131, 11])
array([21, 31, 131, 45])


4  6
2 21
7 98
5 21


%let pgm=utl-select-date-minus-lag-date-in-days-by-group-using-sas-and-sql-in-r-and-python-muti-language;

%stop_submission;

Select date minus lag date in days by group using sas and sql in r and python muti language

OP says it is slow because he/she has a big dataset.
With out knowing the size of the data it is hard measure what slow means.
I suspect the dataset is not big data (ie single table 1tb)

        SOLUTIONS  (slighly different input. Data is sorted by type date)

           0 elegant hash solution no rqire a sort
             Keintz, Mark
             mkeintz@outlook.com
           1 sas datastep
           2 r sql
           3 python sql
           4 r tidyverse (not in base -> group_by %>% lag arrange)

github
https://tinyurl.com/5des9c3v
https://github.com/rogerjdeangelis/utl-select-date-minus-lag-date-in-days-by-group-using-sas-and-sql-in-r-and-python-muti-language

stackoverflow
https://tinyurl.com/2yu98j28
https://stackoverflow.com/questions/79176217/find-number-of-days-in-between-dates-of-observations-belonging-to-the-same-group

related repo
https://tinyurl.com/5azsfab2
https://github.com/rogerjdeangelis/utl-lags-in-proc-sql-monotonic-datastep-is-preferred

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                                        |                                         |                                     */
/*                   INPUT                |                PROCESS                  |           OUTPUT                    */
/*           DATE is DAYS SINCW 1/1/60    |                =======                  |           ======                    */
/*           =========================    |                                         |                                     */
/*                                        |                                         |                                     */
/*  ID    TYPE       DATEC        DATE    | SAS DATASTEP                            | ID TYPE    DATEC     DATE DIFDATE   */
/*                                        | ============                            |                                     */
/*   1    type1    01/01/2014    19724    |                                         |  1 type1 01/01/2014 19724      .    */
/*   2    type2    01/06/2015    20094    | data want;                              |  3 type1 01/06/2015 20094    370    */
/*   3    type1    01/06/2015    20094    |                                         |  4 type1 07/04/2017 21004    910    */
/*   4    type1    07/04/2017    21004    |    %dosubl('                            |  2 type2 01/06/2015 20094      .    */
/*   5    type2    05/10/2018    21314    |     proc sort data=sd1.have             |  5 type2 05/10/2018 21314   1220    */
/*   6    type3    05/01/2026    24227    |          out=havSrt;                    |  6 type3 05/01/2026 24227      .    */
/*                                        |        by type date;                    |                                     */
/*                                        |     run;quit;                           |                                     */
/*                                        |     ');                                 |                                     */
/*                                        |                                         |                                     */
/*                                        |  set havSrt;                            |                                     */
/*                                        |   by type;                              |                                     */
/*                                        |                                         |                                     */
/*                                        |   difdate=dif(date);                    |                                     */
/*                                        |   if first.type then difdate=.;         |                                     */
/*                                        |                                         |                                     */
/*                                        | run;quit;                               |                                     */
/*                                        |                                         |                                     */
/*                                        | --------------------------------------  |                                     */
/*                                        |                                         |                                     */
/*                                        | R AND PYTHON SQL                        |                                     */
/*                                        | ===============                         |                                     */
/*                                        |                                         |                                     */
/*                                        | select                                  |                                     */
/*                                        |      date                               |                                     */
/*                                        |     ,type                               |                                     */
/*                                        |     ,datec                              |                                     */
/*                                        |     ,date - lag(date)                   |                                     */
/*                                        | over                                    |                                     */
/*                                        |     (partition                          |                                     */
/*                                        |         by type                         |                                     */
/*                                        |     order                               |                                     */
/*                                        |         by date) as difference          |                                     */
/*                                        | from                                    |                                     */
/*                                        |     have                                |                                     */
/*                                        | order by                                |                                     */
/*                                        |     type, date                          |                                     */
/*                                        |                                         |                                     */
/*                                        |-----------------------------------------|                                     */
/*                                        |                                         |                                     */
/*                                        | R tidyverse language                    |                                     */
/*                                        |                                         |                                     */
/*                                        | want<-have %>%                          |                                     */
/*                                        |    group_by(TYPE ) %>%                  |                                     */
/*                                        |    arrange(TYPE, DATE) %>%              |                                     */
/*                                        |    mutate(diff=DATE-lag(DATE))          |                                     */
/*                                        |                                         |                                     */
/***************************************************************************************|**********************************/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input ID  type$  datec $10.;
date=input(datec,mmddyy10.);
cards4;
1 type1 01/01/2014
2 type2 01/06/2015
3 type1 01/06/2015
4 type1 07/04/2017
5 type2 05/10/2018
6 type3 05/01/2026
;;;;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  ID    TYPE       DATEC        DATE                                                                                    */
/*                                                                                                                        */
/*   1    type1    01/01/2014    19724                                                                                    */
/*   2    type2    01/06/2015    20094                                                                                    */
/*   3    type1    01/06/2015    20094                                                                                    */
/*   4    type1    07/04/2017    21004                                                                                    */
/*   5    type2    05/10/2018    21314                                                                                    */
/*   6    type3    05/01/2026    24227                                                                                    */
/*                                                                                                                        */
/**************************************************************************************************************************/
/*___                    _               _
 / _ \   ___  __ _ ___  | |__   __ _ ___| |__
| | | | / __|/ _` / __| | `_ \ / _` / __| `_ \
| |_| | \__ \ (_| \__ \ | | | | (_| \__ \ | | |
 \___/  |___/\__,_|___/ |_| |_|\__,_|___/_| |_|

*/

data want (drop=_:);
  set have;
  call missing(_prior_date);
  if _n_=1 then do;
   declare hash h ();
     h.definekey('type');
     h.definedata('type','_prior_date');
     h.definedone();
  end;

  if h.find()=0 then difdate=date-_prior_date;
  h.replace(key:type,data:type,data:date);  /*DATE value gets inserted into _PRIOR_DATE in the hash*/
run;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*ID TYPE    DATEC     DATE DIFDATE                                                                                       */
/*                                                                                                                        */
/* 1 type1 01/01/2014 19724      .                                                                                        */
/* 3 type1 01/06/2015 20094    370                                                                                        */
/* 4 type1 07/04/2017 21004    910                                                                                        */
/* 2 type2 01/06/2015 20094      .                                                                                        */
/* 5 type2 05/10/2018 21314   1220                                                                                        */
/* 6 type3 05/01/2026 24227      .                                                                                        */
/*                                                                                                                        */
/*************************************************************************************************************************

/*                       _       _            _
/ |  ___  __ _ ___    __| | __ _| |_ __ _ ___| |_ ___ _ __
| | / __|/ _` / __|  / _` |/ _` | __/ _` / __| __/ _ \ `_ \
| | \__ \ (_| \__ \ | (_| | (_| | || (_| \__ \ ||  __/ |_) |
|_| |___/\__,_|___/  \__,_|\__,_|\__\__,_|___/\__\___| .__/
                                                     |_|
*/

data want;

   %dosubl('
    proc sort data=sd1.have out=havSrt;
       by type date;
    run;quit;
    ');

 set havSrt;
  by type;

  difdate=dif(date);
  if first.type then difdate=.;

  keep id datec date difdate;

run;quit;

proc print data=want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  WANT total obs=6                                                                                                      */
/*                                                                                                                        */
/*   ID      DATEC        DATE     DIF                                                                                    */
/*                                                                                                                        */
/*    1    01/01/2014    19724       .                                                                                    */
/*    3    01/06/2015    20094     370                                                                                    */
/*    4    07/04/2017    21004     910                                                                                    */
/*    2    01/06/2015    20094       .                                                                                    */
/*    5    05/10/2018    21314    1220                                                                                    */
/*    6    05/01/2026    24227       .                                                                                    */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
str(have)
want<-sqldf('
  select
       date
      ,type
      ,datec
      ,date - lag(date)
  over
      (partition
          by type
      order
          by date) as difference
  from
      have
  order by
      type, date
  ')
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                        |                                                                               */
/*  > want                                | SAS                                                                           */
/*                                        |                                                                               */
/*     DATE  TYPE      DATEC difference   | ROWNAMES     DATE    TYPE       DATEC       DIFFERENCE                        */
/*                                        |                                                                               */
/*  1 19724 type1 01/01/2014         NA   |     1       19724    type1    01/01/2014          .                           */
/*  2 20094 type1 01/06/2015        370   |     2       20094    type1    01/06/2015        370                           */
/*  3 21004 type1 07/04/2017        910   |     3       21004    type1    07/04/2017        910                           */
/*  4 20094 type2 01/06/2015         NA   |     4       20094    type2    01/06/2015          .                           */
/*  5 21314 type2 05/10/2018       1220   |     5       21314    type2    05/10/2018       1220                           */
/*  6 24227 type3 05/01/2026         NA   |     6       24227    type3    05/01/2026          .                           */
/*                                         |                                                                               */
/**************************************************************************************************************************/

/*____               _   _                             _
|___ /   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
  |_ \  | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
 ___) | | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
|____/  | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
        |_|    |___/                                |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete pywant;
run;quit;

%utl_pybeginx;
parmcards4;
exec(open('c:/oto/fn_python.py').read())
have,meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat')
have
want=pdsql('''                     \
    select                         \
         date                      \
        ,type                      \
        ,datec                     \
        ,date - lag(date)          \
    over                           \
        (partition                 \
            by type                \
        order                      \
            by date) as difference \
    from                           \
        have                       \
    order by                       \
        type, date                 \
    ''')
print(want);
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
;;;;
%utl_pyendx(resolve=Y);

proc print data=sd1.pywant;
run;quit;


/**************************************************************************************************************************/
/*                                              |                                                                         */
/* PYTHON                                       |                                                                         */
/*                                              |                                                                         */
/*        DATE   TYPE       DATEC  difference   |    DATE    TYPE       DATEC       DIFFERENCE                            */
/*                                              |                                                                         */
/*  0  19724.0  type1  01/01/2014         NaN   |   19724    type1    01/01/2014          .                               */
/*  1  20094.0  type1  01/06/2015       370.0   |   20094    type1    01/06/2015        370                               */
/*  2  21004.0  type1  07/04/2017       910.0   |   21004    type1    07/04/2017        910                               */
/*  3  20094.0  type2  01/06/2015         NaN   |   20094    type2    01/06/2015          .                               */
/*  4  21314.0  type2  05/10/2018      1220.0   |   21314    type2    05/10/2018       1220                               */
/*  5  24227.0  type3  05/01/2026         NaN   |   24227    type3    05/01/2026          .                               */
/*                                              |                                                                         */
/**************************************************************************************************************************/

/*  _            _   _     _
| || |    _ __  | |_(_) __| |_   ___   _____ _ __ ___ ___  ___
| || |_  | `__| | __| |/ _` | | | \ \ / / _ \ `__/ __/ __|/ _ \
|__   _| | |    | |_| | (_| | |_| |\ V /  __/ |  \__ \__ \  __/
   |_|   |_|     \__|_|\__,_|\__, | \_/ \___|_|  |___/___/\___|
                             |___/
*/
%utl_rbeginx;
parmcards4;
library(haven)
library(tidyverse)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
want<-have %>%
   group_by(TYPE ) %>%
   arrange(TYPE, DATE) %>%
   mutate(diff=DATE-lag(DATE))
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                        |                                                                               */
/*  > want                                | SAS                                                                           */
/*                                        |                                                                               */
/*     DATE  TYPE      DATEC difference   | ROWNAMES     DATE    TYPE       DATEC       DIFFERENCE                        */
/*                                        |                                                                               */
/*  1 19724 type1 01/01/2014         NA   |     1       19724    type1    01/01/2014          .                           */
/*  2 20094 type1 01/06/2015        370   |     2       20094    type1    01/06/2015        370                           */
/*  3 21004 type1 07/04/2017        910   |     3       21004    type1    07/04/2017        910                           */
/*  4 20094 type2 01/06/2015         NA   |     4       20094    type2    01/06/2015          .                           */
/*  5 21314 type2 05/10/2018       1220   |     5       21314    type2    05/10/2018       1220                           */
/*  6 24227 type3 05/01/2026         NA   |     6       24227    type3    05/01/2026          .                           */
/*                                        |                                                                               */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
