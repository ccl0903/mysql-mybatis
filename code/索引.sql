#索引
#1、何为索引？
#1.1、什么是索引？索引有何用？
/*
索引就相当于一本书的目录，通过目录可以快速的找到对应的资源。
在数据库方面，查询一张表的时候有两种检索方式：
	第一种方式：全表扫描
	第二种方式：根据索引检索（效率很高）
索引为什么可以提高检索效率呢？
	其实最根本的原理是缩小了扫描的范围。
*/
#1.2、什么情况下使用索引？
/*
①、数据量庞大时需要时使用索引
②、该字段经常出现在where子句后，以这种形式出行说明该字段总被扫描
③、该字段很少执行DML（insert，delete，update）语句，因为索引的底层采用B-Tree（平衡二叉树），
    B-Tree每次修改结点都会去重新构造平衡二叉树，所以执行DML语句后，索引会重新排序
*/
#1.3、索引的细节。
/* 在MySQL中，主键上以及unique字段上都会自动添加索引！！！
索引虽然可以提高检索效率，但是不能随意的添加索引，因为索引也是数据库当中
的对象，也需要数据库不断的维护。是有维护成本的。比如，表中的数据经常被修改
这样就不适合添加索引，因为数据一旦修改，原索引被破坏，索引需要重新排序，进行维护。
*/



#2、索引的创建与删除  索引名格式： 表名_字段名_index
#创建索引： create index 索引名 on 表名(字段名)
CREATE INDEX emp_ename_index ON emp(ename);
#删除索引： drop index 索引名 on 表名
DROP INDEX emp_ename_index ON emp;
#explain 查看是否使用了索引
EXPLAIN SELECT * FROM emp WHERE ename = 'king';


#3、索引失效 【失效不等同于破坏】
#情况1、模糊匹配可能会导致索引失效
/* 当模糊查询以“%”或“_”开头时，会导致索引失效，原因，%或_开发，索引树不知道从那开始遍历，因此会从头开始遍历
  【注意】 开发中使用模糊查询尽量避免以% _ 进行开头，这是一种优化策略
*/
EXPLAIN SELECT * FROM emp WHERE ename LIKE 'king';  #索引实现
EXPLAIN SELECT * FROM emp WHERE ename LIKE 'k_ng';  #索引实现
EXPLAIN SELECT * FROM emp WHERE ename LIKE 'kin_';  #索引实现
EXPLAIN SELECT * FROM emp WHERE ename LIKE '_ing';  #索引失效

#情况2、使用or时，当or两边字段一个有索引，另一个字段没有索引，会导致索引失效，只有or两边字段都有索引，索引才会实现
#【注意】 因为or这种特性，开发中能使用union代替or就尽量使用union，这是一种优化策略
EXPLAIN SELECT * FROM emp WHERE ename = 'king' OR sal = 5000; #索引失效
EXPLAIN SELECT * FROM emp WHERE ename = 'king' UNION SELECT * FROM emp WHERE ename = 'ford' ;  #索引实现
EXPLAIN SELECT * FROM emp WHERE ename = 'king' OR ename = 'ford' ; #索引实现

#情况3、使用复合索引时，没有使用左侧列进行查找，索引失效
/*  复合索引  create index 索引名 on 表名(字段1，字段2...)
    优化策略： 避免在复合索引中使用右侧进行查找
*/
CREATE INDEX emp_index_job_sal ON emp(job,sal);  #复合索引
EXPLAIN SELECT * FROM emp WHERE job = 'clerk'; #索引实现
EXPLAIN SELECT * FROM emp WHERE job = 'clerk' AND sal = 1100;  #索引实现
EXPLAIN SELECT * FROM emp WHERE job = 'clerk';	#索引实现
EXPLAIN SELECT * FROM emp WHERE sal = 1100;   #索引失效
EXPLAIN SELECT * FROM emp WHERE job = 'clerk' OR sal = 1100;

#情况4、where子句中索引列参加运算会导致索引失效
#【注意】 优化策略，不要用索引列进行运算
CREATE INDEX emp_index_sal ON emp(sal);
EXPLAIN SELECT * FROM emp WHERE sal+1 = 1100;  #索引失效
EXPLAIN SELECT * FROM emp WHERE sal = 1100+1;  #索引实现

#情况5、在where子句中使用了函数
EXPLAIN SELECT * FROM emp WHERE LOWER(ename) = 'king';  #索引失效

#4、索引的分类？
/*
	单一索引：给单个字段添加索引
	复合索引: 给多个字段联合起来添加1个索引
	主键索引：主键上会自动添加索引
	唯一索引：有unique约束的字段上会自动添加索引
*/
#===================================================================


#视图（了解）
#1、什么是视图？
#	站在不同的角度去看到数据。（同一张表的数据，通过不同的角度去看待）。
	
#2、怎么创建视图？怎么删除视图？
CREATE VIEW emp_view AS SELECT empno,ename FROM emp_bak;
SELECT * FROM emp_view;
DROP VIEW emp_view;

#3、视图的作用？
#     视图可以隐藏表的实现细节。保密级别较高的系统，数据库只对外提供相关的视图，java程序员只对视图对象进行CRUD。
#====================================================================




#数据的导入与导出
#数据库导出
mysqldump exercise>E:\exercise.sql -uroot -p
#导出数据库中的某张表
mysqldump exercise emp>F:\emp.sql -uroot -p
#数据库导入
source E:\exercise.sql
