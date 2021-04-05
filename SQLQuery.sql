CREATE TABLE [dbo].[status](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar] (100) NOT NULL,
CONSTRAINT [PK_status] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[posts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar] (100) NOT NULL,
CONSTRAINT [PK_posts] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[deps](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar] (100) NOT NULL,
CONSTRAINT [PK_deps] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[persons](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar] (100) NOT NULL,
	[second_name] [varchar] (100) NOT NULL,
	[last_name] [varchar] (100) NOT NULL,
	[date_employ] [datetime] NULL,
	[date_uneploy] [datetime] NULL,
	[status] [int] NOT NULL,
	[id_dep] [int] NOT NULL,
	[id_post] [int] NOT NULL,
CONSTRAINT [PK_ersonss] PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, 
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT status
(name)
values
('status1'),
('status2')

INSERT posts
(name)
values
('Trainee'),
('Specialist'),
('Leader')

INSERT deps
(name)
values
('Development'),
('Sales'),
('Bookkeeping')

INSERT persons
(first_name, second_name, last_name, date_employ, date_uneploy, status, id_dep, id_post)
values
('Sergey','Sergeevich','Sandakov',DATEADD(DAY,-100,GETDATE()),NULL,1,1,1),
('Ilia','Sergeevich','Sandakov',DATEADD(DAY,-110,GETDATE()),NULL,1,2,1),
('Anton','Sergeevich','Sandakov',DATEADD(DAY,-120,GETDATE()),NULL,1,3,1),
('Eugene','Sergeevich','Sandakov',DATEADD(DAY,-130,GETDATE()),NULL,1,1,2),
('Anastasiya','Sergeevna','Sandakova',DATEADD(DAY,-140,GETDATE()),NULL,1,1,3),
('Kirill','Sergeevich','Sandakov',DATEADD(DAY,-100,GETDATE()),DATEADD(DAY,-10,GETDATE()),2,1,1),
('Ivan','Sergeevich','Sandakov',DATEADD(DAY,-100,GETDATE()),DATEADD(DAY,-20,GETDATE()),2,2,1),
('Olga','Sergeevna','Sandakova',DATEADD(DAY,-100,GETDATE()),DATEADD(DAY,-10,GETDATE()),2,3,1),
('Natalia','Sergeevna','Sandakova',DATEADD(DAY,-150,GETDATE()),NULL,2,1,2),
('Oleg','Sergeevich','Sandakov',DATEADD(DAY,-160,GETDATE()),NULL,2,1,3)

SELECT first_name,second_name,last_name,date_employ,date_uneploy,posts.name AS post,deps.name AS dep, status.name AS status FROM persons
	JOIN deps
	ON persons.id_dep=deps.id
	JOIN posts
	ON persons.id_post=posts.id
	JOIN [status]
	ON persons.status=[status].id

SELECT CONCAT(last_name,' ', SUBSTRING(first_name,1,1),'. ',SUBSTRING(second_name,1,1),'.' ) as FIO,posts.name AS post,deps.name AS dep, status.name AS status,date_employ,date_uneploy FROM persons
	JOIN deps
	ON persons.id_dep=deps.id
	JOIN posts
	ON persons.id_post=posts.id
	JOIN [status]
	ON persons.status=[status].id

GO
CREATE PROC Persons_employ 
@date_start [date],
@date_end [date],
@stat [varchar] (100)
AS
BEGIN
	SELECT cast(date_employ as date) as [date],COUNT(*) as count FROM persons 
	JOIN [status]
	ON persons.status=[status].id
	where [status].[name] = @stat And date_employ>@date_start AND date_employ<@date_end
	group by cast(date_employ as date)
END;

GO
CREATE PROC Persons_unemploy 
@date_start [date],
@date_end [date],
@stat [varchar] (100)
AS
BEGIN
	SELECT cast(date_uneploy as date) as [date],COUNT(*) as count FROM persons 
	JOIN [status]
	ON persons.status=[status].id
	where [status].[name] = @stat And date_uneploy>@date_start AND date_uneploy<@date_end
	group by cast(date_uneploy as date)
END;

GO
CREATE PROC Persons_list AS
BEGIN
	SELECT CONCAT(last_name,' ', SUBSTRING(first_name,1,1),'. ',SUBSTRING(second_name,1,1),'.' ) as FIO,posts.name AS post,deps.name AS dep, status.name AS status,date_employ,date_uneploy FROM persons
	JOIN deps
	ON persons.id_dep=deps.id
	JOIN posts
	ON persons.id_post=posts.id
	JOIN [status]
	ON persons.status=[status].id
END;