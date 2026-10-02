extends Node


const TOTAL_CHAVES_NECESSARIAS := 4


var fases_concluidas: Dictionary = {
	2: true,
	3: false,
	4: false,
	5: false,
	6: true,
	7: false,
	8: false,
	9: false
}


var chaves_coletadas: Dictionary = {
	2: true,
	3: true,
	4: true,
	5: true,
	6: false,
	7: false,
	8: false,
	9: false
}


# --------------------------------------------------
# FASES
# --------------------------------------------------

func fase_concluida(numero_fase: int) -> bool:
	return fases_concluidas.get(numero_fase, false)


func concluir_fase(numero_fase: int) -> void:
	if fases_concluidas.has(numero_fase):
		fases_concluidas[numero_fase] = true


# --------------------------------------------------
# CHAVES
# --------------------------------------------------

func chave_coletada(numero_fase: int) -> bool:
	return chaves_coletadas.get(numero_fase, false)


func coletar_chave(numero_fase: int) -> void:
	if chaves_coletadas.has(numero_fase):
		chaves_coletadas[numero_fase] = true


func get_total_chaves() -> int:
	var total := 0

	for coletada in chaves_coletadas.values():
		if coletada:
			total += 1

	return total


# --------------------------------------------------
# FASE FINAL
# --------------------------------------------------

func fase_final_desbloqueada() -> bool:
	return get_total_chaves() >= TOTAL_CHAVES_NECESSARIAS
