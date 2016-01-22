How to use Datachecker
=======================




Machine Requirement
-------------------

This program can be run on any machine that has ruby, preferably the latest. First change to bin directory which contain the programm for your conveniance
we have also included the data file that the program ingest. Once in bin directory, run the following command
 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ruby yt_data_checker.rb full.csv full2.csv [option]  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

where option(above) is `channel_ownership` or `channel_ownership`

> ###### Examples
  Let say that the option is `channel_ownership` then we issue the following command to run the program
>
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ruby yt_data_checker_beta.rb fullscreen_test.csv fullscreen_test2.csv channel_ownership
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>
Or the option is `subscriber_count` the we issue:
>
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ruby yt_data_checker_beta.rb fullscreen_test.csv fullscreen_test2.csv subscriber_count
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------