alter table m_fx_option_noe add tempi number(8);
update m_fx_option_noe set tempi=expiry_time;
ALTER TABLE M_FX_OPTION_NOE MODIFY(EXPIRY_TIME  NULL);
update M_FX_OPTION_NOE set expiry_time=null;
ALTER TABLE M_FX_OPTION_NOE MODIFY(EXPIRY_TIME date);
update M_FX_OPTION_NOE a set expiry_time=(select to_date('01/01/1970'||data,'dd/mm/yyyy hh24:mi')
from a_code_member b where b.group_id=2000023 and code_key=a.tempi and b.status=1);
commit;
ALTER TABLE M_FX_OPTION_NOE MODIFY(EXPIRY_TIME  not NULL);
ALTER TABLE M_FX_OPTION_NOE drop column tempi;

