CREATE DATABASE funcionarios
GO
USE funcionarios
CREATE TABLE Funcionario(
	codigo				INT				NOT NULL
	, nome				VARCHAR(100)	NOT NULL
	, salario			DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigo)
);

CREATE TABLE Dependente(
	codigoFuncionario	INT				NOT NULL
	, nomeDependente	VARCHAR(100)	NOT NULL
	, salarioDependente DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigoFuncionario,nomeDependente)
	CONSTRAINT fk_dependenteFuncionario FOREIGN KEY (codigoFuncionario) REFERENCES tbFuncionario(codigo)
);




--INSERTS 
INSERT INTO	Funcionario(codigo,nome,salario)
	VALUES
		(1,'Fulano',1535)
		, (2,'Cicrano',1578)
		, (3,'Beltrano',1476)
		, (4,'Fulano Silva',1356)
INSERT INTO Dependente(codigoFuncionario,nomeDependente,salarioDependente)
	VALUES 
		(1,'Fulano Jr',300) 
		,(1,'Maria Fulana',300) 
		,(2,'Cicrano Jr',300) 
		,(3,'Betrano Jr',300) 
		,(3,'Maria Beltrana',300)
		,(3,'João Betrano',300)






--1) Function que Retorne uma tabela: 
--(Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)

CREATE FUNCTION fn_salarioFuncDependente()
RETURNS @tabela TABLE(
	nomeFuncionario				VARCHAR(100)
	, nomeDependente			VARCHAR(100)
	, salarioFuncionario		DECIMAL(7,2)
	, salarioDependente			DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @tabela(nomeFuncionario,nomeDependente,salarioFuncionario,salarioDependente)
		SELECT 
			f.nome 
			, d.nomeDependente 
			, f.salario
			, d.salarioDependente
		FROM Funcionario AS f, Dependente AS d
		WHERE f.codigo = d.codigoFuncionario
		RETURN
END

SELECT * FROM fn_salarioFuncDependente()







--2) Scalar Function que Retorne a soma dos Salários dos dependentes, mais a do funcionário
CREATE FUNCTION fn_obterSalarioDependentes(@codigoFuncionario INT)
RETURNS DECIMAL(7,2)
AS 
BEGIN
	DECLARE @salarioDp DECIMAL(7,2)
	SELECT @salarioDp = SUM(salarioDependente)
	FROM Dependente
	WHERE codigoFuncionario = @codigoFuncionario
	RETURN @salarioDp
END

SELECT dbo.fn_obterSalarioDependentes(2)






CREATE FUNCTION fn_obterSalario(@codigoFuncionario INT)
RETURNS DECIMAL(7,2)
AS 
BEGIN
	DECLARE @salario DECIMAL(7,2)
	SELECT @salario = salario
	FROM Funcionario
	WHERE codigo = @codigoFuncionario
	RETURN @salario
END

SELECT dbo.fn_obterSalario(2)








CREATE FUNCTION fn_somarSalarios(@codigoFuncionario INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @salario DECIMAL(7,2)
			, @salarioDp DECIMAL(7,2)
	SELECT @salario = dbo.fn_obterSalario(@codigoFuncionario)
	SELECT @salarioDp = dbo.fn_obterSalarioDependentes(@codigoFuncionario)
	IF(@salarioDp IS NOT NULL)
	BEGIN
		RETURN @salario +  @salarioDp
	END
	RETURN @salario
END
