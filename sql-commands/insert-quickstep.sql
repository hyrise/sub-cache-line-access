COPY customer FROM './tpch-data/quickstep/customer.tbl' WITH (DELIMITER '|');
COPY lineitem FROM './tpch-data/quickstep/lineitem.tbl' WITH (DELIMITER '|');
COPY nation FROM './tpch-data/quickstep/nation.tbl' WITH (DELIMITER '|');
COPY orders FROM './tpch-data/quickstep/orders.tbl' WITH (DELIMITER '|');
COPY part FROM './tpch-data/quickstep/part.tbl' WITH (DELIMITER '|');
COPY partsupp FROM './tpch-data/quickstep/partsupp.tbl' WITH (DELIMITER '|');
COPY region FROM './tpch-data/quickstep/region.tbl' WITH (DELIMITER '|');
COPY supplier FROM './tpch-data/quickstep/supplier.tbl' WITH (DELIMITER '|');