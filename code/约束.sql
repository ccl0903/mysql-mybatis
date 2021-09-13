#约束【重要】
#意义： 在创建表的时候，可以给表的字段添加相应的约束，添加约束的目的是为了保证表中数据的合法性、有效性、完整性。
/* 约束类型
	非空约束： not null
	唯一性约束：unique
	主键约束： primary key（简称pk）
	外键约束： foreign key（简称fk）
小插曲： 在实际开发中数据库脚本可能非常大，记事本本打不开情况下。可以使用  source xx.sql在命令行执行sql脚本
*/
#1、非空约束： not null约束该字段不能为null
CREATE TABLE t_vip(
	id INT,
	username VARCHAR(255) NOT NULL   #名字不能为空
)
DROP TABLE IF EXISTS t_vip;   #删除表t_vip
#2、唯一约束：unique 修饰的字段具有唯一性，不能重复。但可以为NULL
CREATE TABLE t_vip(
	id INT,
	username VARCHAR(255) NOT NULL,  #名字不能为空，列级约束
	email VARCHAR(255) UNIQUE    #email不可以相同
);
#2.1、如何使username与email两个字段联合唯一，unique(字段1，字段2...)
CREATE TABLE t_vip(
	id INT,
	username VARCHAR(255),  
	email VARCHAR(255),    
	UNIQUE(username,email)  #表级约束
);
DESC t_vip;
SELECT id,username,email FROM t_vip;
INSERT INTO t_vip(id,username,email) VALUES (1001,'zhangsan','zhangsan@qq.com');
INSERT INTO t_vip(id,username,email) VALUES (1002,'zhangsan2','zhangsan@qq.com');
INSERT INTO t_vip(id,username,email) VALUES (1003,'zhangsan','zhangsan@qq.com');  #报错，1001与1003的用户名he邮箱相同
#【注意】 unique有列级约束和表级约束，但not null只有列级约束，没有表级约束

#3、主键约束 primary key  主键特点：主键字段中的数据不能为NULL，也不能重复。
#3.1、单一主键
CREATE TABLE t_vip(
	id INT PRIMARY KEY,  #单一主键  
	username VARCHAR(255),  
	email VARCHAR(255) 
);
#3.1、复合主键 
CREATE TABLE t_vip(
	id INT,  
	username VARCHAR(255),  
	email VARCHAR(255), 
	PRIMARY KEY(id,username)   #复合主键是表级约束，把多个字段联合起来当成主键
);
#【注意】在实际开发中不推荐使用复合主键！！！！，且每个表中最多只有一个主键
#3.3、主键自增  
/*根据主键性质来划分：
	自然主键：主键值最好就是一个和业务没有任何关系的自然数。（这种方式是推荐的）
	业务主键：主键值和系统的业务挂钩，例如：拿着银行卡的卡号做主键，拿着身份证号码作为主键。（不推荐用）
	  最好不要拿着和业务挂钩的字段作为主键。因为以后的业务一旦发生改变的时候，主键值可能也需要
	  随着发生变化，但有的时候没有办法变化，因为变化可能会导致主键值重复。
*/	
CREATE TABLE t_vip(
	id INT PRIMARY KEY AUTO_INCREMENT,  #自增主键
	username VARCHAR(255),  
	email VARCHAR(255)
);
# 在开发中我们一般使用图形化界面进行创建表

#4、外键   foreign key
/*
关于外键约束的相关术语：
	外键约束: foreign key
	外键字段：添加有外键约束的字段
	外键值：外键字段中的每一个值。
	语法：FOREIGN KEY(子表字段) REFERENCES 父表(与之对应字段)
*/
/*
* 业务背景：
	请设计数据库表，用来维护学生和班级的信息？
		第一种方案：一张表存储所有数据
		no(pk)			name			classno			classname
		-------------------------------------------------------------------------------------------
		1			zhangsan		101			北京大兴区经济技术开发区亦庄二中高三1班
		2			lisi			101			北京大兴区经济技术开发区亦庄二中高三1班
		3			wanwu			102			北京大兴区经济技术开发区亦庄二中高三2班
		4			zhaoliu			102			北京大兴区经济技术开发区亦庄二中高三2班
		5			tianqi			102			北京大兴区经济技术开发区亦庄二中高三2班
		缺点：冗余。【不推荐】 不符合数据库规范
		第二种方案：两张表（班级表和学生表）
		t_class 班级表
		cno(pk)		cname
		--------------------------------------------------------
		101		北京大兴区经济技术开发区亦庄二中高三1班
		102		北京大兴区经济技术开发区亦庄二中高三2班
		t_student 学生表
		sno(pk)		sname				classno(该字段添加外键约束fk)
		------------------------------------------------------------
		1		zhangsan			101
		2		lisi				101
		3		wanwu				102
		4		zhaoliu				102
		5		tianqi				102
*/
DROP TABLE IF EXISTS t_student;
DROP TABLE IF EXISTS t_class;

CREATE TABLE t_class(
	cno INT PRIMARY KEY,    #班级编号
	classname VARCHAR(255)  #班级名称
);

CREATE TABLE t_student(
	sid INT PRIMARY KEY AUTO_INCREMENT, #学生编号
	sname VARCHAR(255),		    #学生姓名
	cno INT,			    #班级编号
	FOREIGN KEY(cno) REFERENCES t_class(cno)      #被引用的字段不一定是主键，但至少具有unique约束。
)

INSERT INTO t_class(cno,classname) VALUES(101,'北京大兴区经济技术开发区亦庄二中高三1班'), (102,'北京大兴区经济技术开发区亦庄二中高三2班');
INSERT INTO t_student(sname,cno) VALUES('zhangsan',101);
INSERT INTO t_student(sname,cno) VALUES('lisi',101);
INSERT INTO t_student(sname,cno) VALUES('wanwu',102);
INSERT INTO t_student(sname,cno) VALUES('zhaoliu',102);
INSERT INTO t_student(sname,cno) VALUES('tianqi',102);

SELECT s.sid,s.sname,c.classname
FROM t_student s JOIN t_class c ON s.cno = c.cno;

#        外键字段引用其他表的某个字段的时候，被引用的字段必须是主键吗？
#【注意】被引用的字段不一定是主键，但至少具有unique约束。

SHOW CREATE TABLE `emp`
#==================================================================


#表关系
#第一范式 一定要有主键
#第二范式 多对多？三张表，关系表两个外键
#第三方式 一对多，两张表，多的表加外键。

