# utl-indirect-addressing-indexed-lookup-in-sas-r-and-python-sql-multi-language
Indirect addressing indexed lookup in sql sas r python multi language
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
