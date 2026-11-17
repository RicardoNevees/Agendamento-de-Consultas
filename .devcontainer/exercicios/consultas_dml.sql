-- ============================================================
-- Exercício 02 - Comandos DML - Agendamento de Consultas
-- ============================================================

-- INSERT: cadastrar as pessoas (pacientes e médicos)
INSERT INTO pessoa (cpf, email, nome, data_nasc, endereco, telefone) VALUES
('002', 'pp@email.com', 'Pedro I',   '1479-01-10', 'R. Vasco',    NULL),
('003', 'ps@email.com', 'Pedro II',  '1516-02-10', 'R. Flamengo', '5501'),
('001', 'dj@email.com', 'D João VI', '1415-12-01', 'R. Portugal', NULL),
('004', 'jj@email.com', 'JJ Xavier', '1746-11-12', 'R. Minas',    '5502');

-- INSERT: cadastrar os pacientes
INSERT INTO paciente (cpf_pessoa, senha, plano_saude) VALUES
('002', 'senha1', false),
('003', 'senha2', true);

-- INSERT: cadastrar os médicos
INSERT INTO medico (cpf_pessoa, crm) VALUES
('001', '111'),
('004', '112');

-- INSERT: cadastrar as especialidades
INSERT INTO especialidade (id, descricao) VALUES
(1, 'Pediatra'),
(2, 'Cardiologista'),
(3, 'Ortopedista');

-- INSERT: associar os médicos às especialidades
INSERT INTO medico_especialidade (cpf_medico, id_especialidade) VALUES
('001', 1),
('004', 2),
('004', 3);

-- INSERT: cadastrar os agendamentos
INSERT INTO agendamento (cpf_paciente, cpf_medico, dh_consulta, dh_agendamento, valor_consulta) VALUES
('002', '001', '1782-04-14 16:00:00', '1782-03-14 10:04:45', 80),
('002', '004', '1782-04-15 10:00:00', '1782-03-14 10:04:45', 100),
('002', '004', '1783-05-17 08:00:00', '1783-05-10 16:32:00', 100),
('003', '001', '1783-05-17 08:30:00', '1783-05-09 09:05:56', 0);

-- UPDATE: D João VI nasceu em 01-12-1416
UPDATE pessoa SET data_nasc = '1416-12-01' WHERE nome = 'D João VI';

-- UPDATE: telefone e e-mail de Pedro I
UPDATE pessoa SET telefone = '5503', email = 'pf@email.com' WHERE nome = 'Pedro I';

-- UPDATE: adicionar o dígito 9 no início dos telefones
UPDATE pessoa SET telefone = '9' || telefone WHERE telefone IS NOT NULL;

-- UPDATE: adiar as consultas de 17-05-1783 para 19-05-1783
-- e alterar o valor para R$ 150,00, mantendo R$ 0,00 para quem tem plano de saúde
UPDATE agendamento a
SET dh_consulta = a.dh_consulta + INTERVAL '2 days',
    valor_consulta = CASE WHEN p.plano_saude THEN 0 ELSE 150 END
FROM paciente p
WHERE p.cpf_pessoa = a.cpf_paciente
  AND a.dh_consulta::date = DATE '1783-05-17';

-- UPDATE: JJ Xavier deixa de ser Cardiologista e passa a ser Pediatra (continua Ortopedista)
UPDATE medico_especialidade
SET id_especialidade = 1
WHERE cpf_medico = '004' AND id_especialidade = 2;

-- DELETE: Pedro I cancelou a consulta de 19-05-1783
DELETE FROM agendamento
WHERE cpf_paciente = '002' AND dh_consulta::date = DATE '1783-05-19';

-- DELETE: agendamentos do médico D João VI com valor R$ 0,00
DELETE FROM agendamento
WHERE cpf_medico = '001' AND valor_consulta = 0;

-- DELETE: pacientes com plano de saúde ou sem telefone
DELETE FROM paciente p
USING pessoa pe
WHERE pe.cpf = p.cpf_pessoa
  AND (p.plano_saude = TRUE OR pe.telefone IS NULL);

-- DELETE: agendamentos do médico JJ Xavier (dependência de FK)
DELETE FROM agendamento WHERE cpf_medico = '004';

-- DELETE: associações de JJ Xavier com especialidades (dependência de FK)
DELETE FROM medico_especialidade WHERE cpf_medico = '004';

-- DELETE: médico JJ Xavier
DELETE FROM medico WHERE cpf_pessoa = '004';
