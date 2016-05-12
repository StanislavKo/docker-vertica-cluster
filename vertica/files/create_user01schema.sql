CREATE USER user01 IDENTIFIED BY 'user01password';
GRANT USAGE ON SCHEMA PUBLIC to user01;

CREATE SCHEMA user01schema;
CREATE TABLE user01schema.table_street (
       MAPBLKLOT                      varchar(32) NOT NULL,   
       STREET                         varchar(100),
       ST_TYPE                        varchar(32),
       BLOCK_NUM                      varchar(32),
       COLUMN01                       integer,
       COLUMN02                       integer,
       COLUMN03                       integer,
       COLUMN04                       integer,
       COLUMN05                       integer,
       COLUMN06                       integer,
       COLUMN07                       integer,
       COLUMN08                       integer,
       COLUMN09                       integer,
       COLUMN10                       integer,
       COLUMN11                       integer,
       COLUMN12                       integer,
       COLUMN13                       integer,
       COLUMN14                       integer,
       COLUMN15                       integer,
       COLUMN16                       integer,
       COLUMN17                       integer,
       COLUMN18                       integer,
       COLUMN19                       integer
);
CREATE FLEX TABLE user01schema.kafka_tgt();

GRANT USAGE ON SCHEMA user01schema TO user01;
GRANT ALL PRIVILEGES ON TABLE user01schema.table_street TO user01;
GRANT ALL PRIVILEGES ON TABLE user01schema.kafka_tgt TO user01;


