CREATE OR REPLACE FUNCTION public.f_test(name_part VARCHAR(255))
    RETURNS TABLE (id bigint, name varchar(255))
     LANGUAGE plpgsql
 AS
$$
BEGIN
RETURN QUERY SELECT tbl_test.id, tbl_test.name FROM public.tbl_test WHERE tbl_test.name LIKE '%' || name_part || '%';
END;
$$
;