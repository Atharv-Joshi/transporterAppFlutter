package com.liveasy.liveasy.requestsCellInfo

data class CellInfo(
    var radio: String? = null,
    var mcc: Int? = null,
    var mnc: Int? = null,
    var cells: List<Cell> = emptyList(),
    var signal: Int? = 0
)

data class Cell(
    val lac: Int,
    val cid: Int,
    val psc: Int? = null
)

object RadioType {
    const val GSM = "gsm"
    const val CDMA = "cdma"
    const val UMTS = "umts"
    const val LTE = "lte"
}
