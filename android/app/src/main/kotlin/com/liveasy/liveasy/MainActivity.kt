@file:Suppress("DEPRECATION")
package com.liveasy.liveasy
import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.telephony.CellInfoGsm
import android.telephony.CellInfoLte
import android.telephony.CellInfoWcdma
import android.telephony.TelephonyManager
import androidx.annotation.NonNull
import com.liveasy.liveasy.requestsCellInfo.Cell
import com.liveasy.liveasy.requestsCellInfo.CellInfo
import com.liveasy.liveasy.requestsCellInfo.RadioType
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.gson.Gson

class MainActivity : FlutterActivity() {
    private val CHANNEL = "livelocation.flutter.dev/simlocation"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        println("It is in first functions of kotlin")
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            println("It is in second functions of kotlin")
            if (call.method == "getKotlinLocation") {
                val allCellInfo = getCurrentCellInfo()
                allCellInfo.forEachIndexed { index, cellInfo ->
                    val gson = Gson()
                    println("We are in method")
                    val cellInfoh = CellInfo(
                        "${cellInfo.radio}",
                        cellInfo.mcc,
                        cellInfo.mnc,
                        cellInfo.cells,
                        cellInfo.signal,
                    )
                    val jsoncellInfo5 = gson.toJson(cellInfoh)
                    println("Cell Info in jSON is $jsoncellInfo5")
                    println("Whole Cell Info is $cellInfo")
                    println("Size of List of Cells is ${cellInfo.cells.size}")
                    println("List of Cells is ${cellInfo.cells}")
                    println("CID is ${cellInfo.cells[index].cid}")
                    println("LAC is ${cellInfo.cells[index].lac}")
                    println("PSC is ${cellInfo.cells[index].psc}")
                    println("MCC is ${cellInfo.mcc}")
                    println("MNC is ${cellInfo.mnc}")
                    println("Radio is ${cellInfo.radio}")
                    println("Signal Strength is (RSRP) ${cellInfo.signal}")
                    result.success(jsoncellInfo5)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    @SuppressLint("MissingPermission")
    fun getCurrentCellInfo(): List<CellInfo> {
        println("It is in getCurrentCellInfo function")
            val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            val allCellInfo = telephonyManager.allCellInfo
            return allCellInfo.mapNotNull {
                when (it) {
                    is CellInfoGsm -> getCellInfo(it)
                    is CellInfoWcdma -> getCellInfo(it)
                    is CellInfoLte -> getCellInfo(it)
                    else -> null
                }
            }
    }

    fun getCellInfo(info: CellInfoGsm): CellInfo {
        println("It is in getCellInfo GSM function")
        val cellInfo = CellInfo()
        cellInfo.radio = RadioType.GSM

        info.cellIdentity.let {
            val (mcc, mnc) = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                Pair(it.mccString?.toInt() ?: 0, it.mncString?.toInt() ?: 0)
            } else {
                Pair(it.mcc, it.mnc)
            }
            cellInfo.mcc = mcc
            cellInfo.mnc = mnc
            cellInfo.cells = listOf(Cell(it.lac, it.cid, it.psc))
        }
        cellInfo.signal = info.cellSignalStrength.dbm
        return cellInfo
    }

    fun getCellInfo(info: CellInfoWcdma): CellInfo {
        println("It is in getCellInfo WCDMA function")
        val cellInfo = CellInfo()

        cellInfo.radio = RadioType.CDMA

        info.cellIdentity.let {
            val (mcc, mnc) = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                Pair(it.mccString?.toInt() ?: 0, it.mncString?.toInt() ?: 0)
            } else {
                Pair(it.mcc, it.mnc)
            }
            cellInfo.mcc = mcc
            cellInfo.mnc = mnc
            cellInfo.cells = listOf(Cell(it.lac, it.cid, it.psc))
        }
        cellInfo.signal = info.cellSignalStrength.dbm
        return cellInfo
    }

    fun getCellInfo(info: CellInfoLte): CellInfo {
        println("It is in getCellInfo LTE function")
        val cellInfo = CellInfo()

        cellInfo.radio = RadioType.LTE

        info.cellIdentity.let {
            val (mcc, mnc) = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                Pair(it.mccString?.toInt() ?: 0, it.mncString?.toInt() ?: 0)
            } else {
                Pair(it.mcc, it.mnc)
            }
            cellInfo.mcc = mcc
            cellInfo.mnc = mnc
            cellInfo.cells = listOf(Cell(it.tac, it.ci, it.pci))
        }
        cellInfo.signal = info.cellSignalStrength.dbm
        return cellInfo
    }
}