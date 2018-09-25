Monitor
=======

Warning
-------
select 1 from FEED_MONITORING where STATUS in ('WARNING') and rownum<2;

Critical
--------
select 1 from FEED_MONITORING where STATUS in ('CRITICAL') and rownum<2;





Return Value
============
select * from FEED_MONITORING order by STATUS;