drop database if exists transacciones;

create database transacciones;
use transacciones;

create table clientes(
	cedula int primary key,
    nombres varchar(30) not null,
    apellidos varchar(30) not null,
    telefono varchar(12) not null
);

create table cuentas(
	num_cuenta int primary key,
    id_cliente int,
    saldo int unsigned,
    foreign key (id_cliente) references clientes(cedula)
);

create table transferencias(
	id int primary key auto_increment,
    cuenta_origen int,
    cuenta_destino int,
    valor_enviar int,
    fecha datetime,
    foreign key (cuenta_origen) references cuentas(num_cuenta),
    foreign key (cuenta_destino) references cuentas(num_cuenta)
);

insert into clientes(cedula, nombres, apellidos, telefono) values (52790002, 'Juliana', 'Rodriguez Sánchez', 3124351376);
insert into clientes(cedula, nombres, apellidos, telefono) values (1020804780, 'Nicolas', 'Torres Méndez', 3056402442);

insert into cuentas(num_cuenta, id_cliente, saldo) values (0043384497, 52790002, 80000);
insert into cuentas(num_cuenta, id_cliente, saldo) values (0071383021, 1020804780, 20000);


drop procedure if exists transferenciaBancaria;

delimiter //
create procedure transferenciaBancaria(
	in cuentaOrigen int,
    in cuentaDestino int,
    in valorEnviar int
)
begin
	declare exit handler for 1690
    begin
		select 'Saldo insuficiente';
        rollback;
    end; 
    start transaction;
   	update cuentas set saldo = saldo - valorEnviar where num_cuenta = cuentaOrigen;
	update cuentas set saldo = saldo + valorEnviar where num_cuenta = cuentaDestino;
	insert into transferencias (cuenta_origen, cuenta_destino, valor_enviar, fecha) 
	values (cuentaOrigen, cuentaDestino, valorEnviar, now());
    commit;
end 
//

call transferenciaBancaria(0043384497, 0071383021, 20000);
call transferenciaBancaria(0071383021, 0043384497, 5000);
call transferenciaBancaria(0043384497, 0071383021, 100000);

select * from cuentas;
select * from transferencias;
