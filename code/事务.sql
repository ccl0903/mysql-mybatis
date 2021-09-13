#事务： transaction
#一个事务就是一个完整的业务逻辑
/*	只有DML语句（insert，update，delete）才有事务这一说
	事务本质上可以看做多条DML语句同时成功，或者同时失败！！！
	innoDB存储引擎支持事务
 【原理||重要】 事务如何做到几条DML语句同时成功，同时失败？
    因为InnoDB引擎提供一组用来记录事务性活动的日志文件
   【事务的执行流程】
	事务开启了
	insert
	insert
	insert
	delete
	delete
	update
	事务结束
	事务在执行的过程中，每一条DML语句操作都会记录到“记录事务性活动的日志文件”中
	在事务的执行过程中，我们可以提交事务【commit】，也可以回滚事务【rollback】
    提交事务？
	清空事务性活动的日志文件，将数据持久化到数据库表中去，提交事务意味着事务结束并成功执行。
    回滚事务？
         将之前所有DML操作全部撤销，并清空事务性活动的日志文件,事务回滚意味事务结束且之前DML没有执行。
mysql默认开启自动提交
	保留点（ savepoint）指事务处理中设置的临时占位符（ placeholder）
	你可以对它发布回退（与回退整个事务处理不同）
*/
DROP TABLE IF EXISTS dept_bak;
CREATE TABLE dept_bak AS SELECT * FROM dept;
SELECT * FROM dept_bak;
#事务演示
#====提交====
START TRANSACTION;
INSERT INTO dept_bak (deptno,dname,loc) VALUES (50,'后勤','广东');
INSERT INTO dept_bak (deptno,dname,loc) VALUES (60,'销售','广东');
DELETE FROM dept_bak WHERE deptno = 60;
UPDATE dept_bak SET dname='管理',loc = '上海' WHERE deptno = 50;
COMMIT;
SELECT * FROM dept_bak;
#====回滚====
START TRANSACTION;
INSERT INTO dept_bak (deptno,dname,loc) VALUES (70,'策划','广东');
INSERT INTO dept_bak (deptno,dname,loc) VALUES (80,'人事','广东');
DELETE FROM dept_bak WHERE deptno = 60;
UPDATE dept_bak SET dname='研发',loc = '上海' WHERE deptno = 50;
ROLLBACK;
SELECT * FROM dept_bak;
#====保留点======
START TRANSACTION;
INSERT INTO dept_bak (deptno,dname,loc) VALUES (70,'策划','广东');
INSERT INTO dept_bak (deptno,dname,loc) VALUES (80,'人事','广东');
SAVEPOINT  updateTwo    #设置一个保留点
DELETE FROM dept_bak WHERE deptno = 60;
UPDATE dept_bak SET dname='研发',loc = '上海' WHERE deptno = 50;
ROLLBACK TO updateTwo;	#事务回滚到保留点
SELECT * FROM dept_bak;
#=========================================================


#事务的隔离级别
/*
关于事务之间的隔离性
	事务隔离性存在隔离级别，理论上隔离级别包括4个：
		第一级别：读未提交（read uncommitted）
			对方事务还没有提交，我们当前事务可以读取到对方未提交的数据。
			读未提交存在脏读（Dirty Read）现象：表示读到了脏的数据。
	【重要】第二级别：读已提交（read committed）
			【对方事务一旦提交数据我方就可以立即读取到】
			这种隔离级别解决了: 脏读现象没有了。
			读已提交存在的问题是：不可重复读。
	【重要】第三级别：可重复读（repeatable read）  
		(读取不到别的事务提交的数据，永远只能读到刚开启事务时的数据)
			这种隔离级别解决了：不可重复读问题。
			这种隔离级别存在的问题是：读取到的数据是幻象。
		第四级别：序列化读/串行化读（serializable） 
			解决了所有问题。
			效率低。需要事务排队，不支持并发。
	
	oracle数据库默认的隔离级别是：读已提交。
	mysql数据库默认的隔离级别是：可重复读。
*/



















