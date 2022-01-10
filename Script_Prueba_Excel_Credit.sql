/*
 * 
 * Prueba Excel Credit
 * Autor: Daniel Beltran
 * 
 */

-- Creacion tabla principal

drop table if exists prueba_excel_credit.tmp_tratados_int_Col; 
create table prueba_excel_credit.tmp_tratados_int_Col
	(
	  Nombre_del_Tratado TEXT
	, Bilateral TEXT
	, Lugar_de_Adopcion TEXT
	, Fecha_de_Adopcion TEXT
	, Estados_Organismos TEXT
	, Temas TEXT
	, Naturaleza_del_Tratado TEXT
	, Depositario TEXT
	, Suscribio_Por_Colombia TEXT
	, Vigente TEXT
	, Fecha_Ley_Aprobatoria TEXT
	, Numero_Ley_Aprobatoria TEXT
	, Sentencia_Fecha_Ley TEXT
	, Sentencia_Numero TEXT
	, Decreto_Fecha_Diario_Oficial TEXT
	, Decreto_Numero_Diario_Oficial TEXT
	, Pais_del_Tratado TEXT
	, Codigo_de_llamadas TEXT
	, Capital TEXT
	, Region TEXT
	, Subregion TEXT
	, Poblacion TEXT
	, Area_ int
	, Zona_Horaria TEXT
	, Monedas TEXT
	, Idiomas TEXT
	, Cantidad_Fronteras int
	, Diferencia_Hora_Zona_Horaria float
	);

/* 
 * Validacion de datos 

	select distinct bilateral 
	from prueba_excel_credit.tmp_tratados_int_Col;

	select Count(1) cantidad_registros
	from prueba_excel_credit.tmp_tratados_int_Col;
*/	

--Creacion tabla ajustada 

drop table if exists tmp_tratados_int_col_dep;
create temp table tmp_tratados_int_col_dep as
	select
		nombre_del_tratado,
		case when bilateral = 'SI' then true else false end bilateral,
		lugar_de_adopcion,
		case  when fecha_de_adopcion = '31/09/2008' then '2008-09-30'::date    
			  when fecha_de_adopcion = '31/06/1979' then '1979-06-30'::date
			  when fecha_de_adopcion = '29/02/2001' then '2001-02-28'::date
			  when fecha_de_adopcion = '31/04/1951' then '1951-04-30'::date
			  else to_char(fecha_de_adopcion::Date,'YYYY-MM-DD')::date 
		end fecha_de_adopcion, 
		estados_organismos,
		case when temas = '(NO REGISTRA)' then null else temas  end temas,
		naturaleza_del_tratado,
		case when depositario = '(NO REGISTRA)' then null else depositario end depositario, 
		suscribio_por_colombia,
		case when vigente = 'SI' then true else false end vigente,
		case when fecha_ley_aprobatoria = '(NO REGISTRA)' then null 
			 when fecha_ley_aprobatoria = '31/09/2008' then '2008-09-30'::date    
		  	 else to_char(fecha_ley_aprobatoria::date,'YYYY-MM-DD')::Date 
		end fecha_ley_aprobatoria, 
		case when numero_ley_aprobatoria = '(NO REGISTRA)' then null else numero_ley_aprobatoria end numero_ley_aprobatoria, 
		case when sentencia_fecha_ley = '(NO REGISTRA)' then null 
			 when sentencia_fecha_ley = '31/09/2008' then '2008-09-30'::date    
			else to_char(sentencia_fecha_ley::date,'YYYY-MM-DD')::Date 
		end sentencia_fecha_ley, 
		case when sentencia_numero = '(NO REGISTRA)' then null else sentencia_numero end sentencia_numero,
		case when decreto_fecha_diario_oficial = '(NO REGISTRA)' then null 
			 when decreto_fecha_diario_oficial = '31/09/2008' then '2008-09-30'::date    
			 when decreto_fecha_diario_oficial = '29/02/2001' then '2001-02-28'::date
			 else to_char(decreto_fecha_diario_oficial::date,'YYYY-MM-DD')::Date 
		end decreto_fecha_diario_oficial, 
		case when decreto_numero_diario_oficial = '(NO REGISTRA)' then null else decreto_numero_diario_oficial end decreto_numero_diario_oficial,
		pais_del_tratado,
		codigo_de_llamadas,
		capital,
		region,
		subregion,
		poblacion,
		area_,
		zona_horaria,
		monedas,
		idiomas,
		cantidad_fronteras,
		diferencia_hora_zona_horaria
	from prueba_excel_credit.tmp_tratados_int_Col;

/* 
 * Validacion de datos
 	select *
	from tmp_tratados_int_col_dep;

*/	

--Creacion tabla agrupada
drop table if exists agrupacion_por_pais; 
create table agrupacion_por_pais as	
	select lugar_de_adopcion pais
				,count(1)filter(where vigente is true) cantidad_de_tratados_vigentes
				,count(1)filter(where vigente is false) cantidad_de_tratados_no_vigentes
				, min(fecha_de_adopcion) min_fecha_adopcion
				,round(((to_char(now()::Date,'yyyymm')::int - to_char(min(fecha_de_adopcion),'yyyymm')::int)/365::float)*12::numeric) diferencia_en_meses
	from tmp_tratados_int_col_dep
	group by 1;

/*
 * Validacion datos
 *select *
 *from agrupacion_por_pais 
 */