CREATE OR REPLACE FORCE VIEW feed_statistics (
   tp_id,
   orig_inter_val,
   top_wait
   )
AS
   SELECT tp_id,        --(SELECT NAME FROM A_ORGANIZATION WHERE ID=TP_ID) TP,
          orig_inter_val,
          MAX(t1_final)
             OVER
             (
                PARTITION BY tp_id
                ORDER BY tp_id, orig_inter_val
                ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
             )
             AS top_wait
   FROM (WITH a
                AS (SELECT x1.tp_id, x1.inter_val, y1.t1
                    FROM (SELECT is1_b.tp_id, is1_a.t2 AS inter_val
                          FROM (SELECT ROWNUM - 1 AS t2
                                FROM fxcm_prod.fd_fxpb_linear_ta
                                WHERE ROWNUM <= 144) is1_a,
                               (SELECT DISTINCT decode(tp_id,6000201,6000200,
                                                             6000202,6000200,
                                                             6000203,6000200,
                                                             6000204,6000200,
                                                             6000205,6000200,tp_id) tp_id
                                FROM fxcm_prod.fd_fxpb_linear_ta
                                WHERE (creation_date between trunc(sysdate-7) AND trunc(sysdate))
                                      and trunc(creation_date) not in (next_day(trunc(sysdate-10),'SATURDAY'),next_day(trunc(sysdate-10),'SUNDAY')))
                               is1_b) x1,
                         -- getting the 2nd highest daily max diff
                         (SELECT tp_id, inter_val, t1
                          FROM (     -- giving ranks to 5 max daily time diffs
                                SELECT tp_id,
                                       inter_val,
                                       t1,
                                       RANK ()
                                          OVER
                                          (
                                             PARTITION BY tp_id, inter_val
                                             ORDER BY t1 DESC
                                          )
                                          RANK
                                FROM ( -- max daily time diff
                                      SELECT tp_id,
                                             creation_date,
                                             inter_val,
                                             MAX (t1) t1
                                      FROM ( -- time diffs between 10 msgs from all the last week
                                            (SELECT decode(tp_id,6000201,6000200,
                                                                 6000202,6000200,
                                                                 6000203,6000200,
                                                                 6000204,6000200,
                                                                 6000205,6000200,tp_id) tp_id,
                                                    TRUNC (creation_date)
                                                       creation_date,
                                                    TRUNC( (creation_date
                                                            - TRUNC(creation_date))
                                                          * 144)
                                                       inter_val,
                                                    (creation_date
                                                     - TRUNC (creation_date))
                                                    * 24
                                                    * 3600
                                                    - LAG ( (creation_date
                                                             - TRUNC(creation_date))
                                                           * 24
                                                           * 3600,
                                                           10,
                                                           0
                                                      )
                                                         OVER
                                                         (
                                                            PARTITION BY decode(tp_id,6000201,6000200,
                                                                                      6000202,6000200,
                                                                                      6000203,6000200,
                                                                                      6000204,6000200,
                                                                                      6000205,6000200,tp_id),
                                                                         TRUNC(creation_date)
                                                            ORDER BY
                                                               decode(tp_id,6000201,6000200,
                                                                                      6000202,6000200,
                                                                                      6000203,6000200,
                                                                                      6000204,6000200,
                                                                                      6000205,6000200,tp_id),
                                                               creation_date
                                                         )
                                                       AS t1
                                             FROM fxcm_prod.fd_fxpb_linear_ta
                                             WHERE (creation_date between trunc(sysdate-7) AND trunc(sysdate))
                                                   and trunc(creation_date) not in (next_day(trunc(sysdate-10),'SATURDAY'),next_day(trunc(sysdate-10),'SUNDAY'))))
                                      GROUP BY tp_id, creation_date, inter_val))
                          WHERE RANK = 2
                          -- GROUP BY eliminates duplicates caused by RANK
                          GROUP BY tp_id, inter_val, t1) y1
                    WHERE x1.tp_id = y1.tp_id(+)
                          AND x1.inter_val = y1.inter_val(+))
         SELECT m.tp_id tp_id,
                m.inter_val orig_inter_val,
                --M.T1,
                NVL (m.t1,
                     (m.inter_val
                      - (SELECT NVL (MAX (inter_val), -1)
                         FROM a
                         WHERE     a.tp_id = m.tp_id
                               AND a.t1 IS NOT NULL
                               AND a.inter_val <= m.inter_val))
                     * 600
                     -- EMPTY_INTER_VALS_SO_FAR,
                     + (SELECT NVL (t1, 0)
                        FROM a
                        WHERE a.tp_id = m.tp_id
                              AND inter_val =
                                    (SELECT NVL (MAX (inter_val), 0)
                                     FROM a
                                     WHERE     a.tp_id = m.tp_id
                                           AND a.t1 IS NOT NULL
                                           AND a.inter_val <= m.inter_val))
                )
                   t1_final
         --LAST_ACTIVE_T1
         FROM a m
         ORDER BY tp_id, orig_inter_val);

