#DDL语句  【create，drop，alter】
#1、mysql的数据类型
/*	varchar   动态分配内存空间	
		  优点：节省空间 缺点：速度慢
	char	  定长，不管数据长度，直接分配分配空间
		  优点：速度快 缺点：节省空间
	姓名是不确定长度使用varchar  性别是固定的使用char
	int		整数型(java中的int)
	bigint		长整型(java中的long)
	float		浮点型(java中的float double)
	char		定长字符串(String)
	varchar		可变长字符串(StringBuffer/StringBuilder)
	date		短日期（包含年月日信息） 日期类型 （对应Java中的java.sql.Date类型）
	datetime        长日期 （包含年月日时分秒信息）
	BLOB		二进制大对象（存储图片、视频等流媒体信息） Binary Large OBject （对应java中的Object）
	CLOB		字符大对象（存储较大文本，比如，可以存储4G的字符串。） Character Large OBject（对应java中的Object）
	
*/
#2、建表
CREATE TABLE t_student(
	sno INT,
	sname VARCHAR(30),
	sex CHAR(1) DEFAULT 'm',
	age INT(3),
	email VARCHAR(255),
	enrollment DATE
);
DESC t_student;

#3、删除表  【记住以下格式】
DROP TABLE IF EXISTS  t_student;
#===================================================================


#DML语句
#1、insert into插入语句；
/*语法格式   insert into 表名(字段名1,字段名2,字段名3,....) values(值1,值2,值3,....)
	     要求：字段的数量和值的数量相同，并且数据类型要对应相同。
*/
# 补充  插入带时间的数据,需要用到str_to_date函数(字符串转时间)，查询时间用date_format（时间转字符串）
/*	年要记得大写%Y  不能是%y
	mysql的时间格式 %Y 年	%m 月	%d 日	%h 时	 %i 分	 %s 秒
	要插入特定格式必须使用str_to_date
	str_to_date('01-10-2021','%d-%m-%y')
	str_to_date('2021-08-21','%y-%m-%d')
	【注意】 如果插入格式为 '%y-%m-%d',可以省略str_to_date,直接写时间字符串
	'2021-08-22'
*/
INSERT INTO t_student(sno,sname,sex,age,email,enrollment) VALUES ('1001','zhangsan','m',18,'zhangsan@qq.com',STR_TO_DATE('01-10-2021','%d-%m-%Y'));
INSERT INTO t_student(sno,sname,sex,age,email,enrollment) VALUES ('1002','lisi','f',19,'lisi@qq.com',STR_TO_DATE('2021-08-21','%Y-%m-%d'));
INSERT INTO t_student(sno,sname,sex,age,email,enrollment) VALUES ('1003','wanwu','m',20,'wanwu@qq.com','2020-08-22');
/*
	date_format(字段名,格式)
	【例子】 date_format(enrollment,'%Y/%m/%d')
	默认不使用date_format，会输出 %Y-%m-%d 形式
*/
SELECT sname,age,DATE_FORMAT(enrollment,'%Y/%m/%d') '入学时间' FROM t_student;
SELECT sno,sname,age,enrollment FROM t_student;

/*	date		短日期（包含年月日信息） 日期类型 （对应Java中的java.sql.Date类型）
	datetime        长日期 （包含年月日时分秒信息）
	date的默认时间格式  	%Y-%m-%d
	datetime默认时间格式	%Y-%m-%d %h:%i%s
	now()函数，获取当前系统时间（是datetime类型）
*/
#insert into 一次性插入多条记录 语法  insert into 表名(字段名1,字段名2...) values (),(),(),()...;
INSERT INTO t_student(sno,sname,sex,age,email,enrollment) 
	VALUES  ('1003','wanwu','m',20,'wanwu@qq.com','2020-08-22'),
		('1004','zaholiu','m',21,'zhaoliu@qq.com','2020-08-22'),
		('1005','tianqi','m',18,'tianqi@qq.com','2020-08-22');



#修改 update
/*语法格式：
	update 表名 set 字段名1=值1,字段名2=值2... where 条件;

	【注意】没有条件整张表数据全部更新。
	写sql语句时避免出现这种情况： UPDATE t_student SET sname = '陈帅帅';
	
*/
UPDATE t_student SET sname = 'wanwu弟弟',age = 18 WHERE sno = '1003';
#UPDATE t_student SET sname = '陈帅帅';

#删除 delete
/*语法格式：
	delete from 表名 where 条件;
	注意：没有条件全部删除。
*/
DELETE FROM t_student WHERE sno = '1003';
#===========================================================================


#快速创建表
#表的复制
/*原理：
	将一个查询结果当做一张表新建
	同时将表中数据进行粘贴到新表，完成一次表单复制（备份）
*/
CREATE TABLE emp_bak AS SELECT * FROM emp;
SELECT * FROM emp_bak;

#删除表中数据
#删除emp_bak中的数据
#delete from 表名   这种删除效率低，表中数据被删除，当硬盘中真实存储空间不会释放，且支持回滚
#delete from dept_bak;
#怎么删除大表中的数据？（重点）
#truncate table 表名; // 表被截断，不支持回滚。永久丢失,truncate table 表名; （属于DDL操作）
#========================================================================================