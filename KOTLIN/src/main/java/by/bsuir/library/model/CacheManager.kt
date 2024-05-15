package by.bsuir.library.model

import android.content.Context
import com.google.firebase.storage.StorageReference
import kotlinx.coroutines.async
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.tasks.await
import java.io.File
import java.util.Calendar

class CacheManager(context: Context, source: StorageReference, nMinutesTimeout: Int) {
    private val _cacheUpdaterSource: StorageReference = source
    private val _cacheDirectory: File = context.cacheDir
    private val _nMinutesCacheTimeout: Int = nMinutesTimeout
    private val _inMemoryCache: MutableMap<String, ByteArray> = mutableMapOf()

    init {
        _cacheDirectory.listFiles()?.forEach {
            _inMemoryCache[it.path.split("/").last()] = byteArrayOf()
        }
    }

    private fun add(data: ByteArray, name: String){
        _inMemoryCache[name] = data
        val toSave = File("${_cacheDirectory.path}/$name")

        toSave.outputStream().write(data)
    }

    suspend fun get(name: String): ByteArray = coroutineScope{
        if (_inMemoryCache.containsKey(name)) {
            val file = File("${_cacheDirectory.path}/$name")

            if (_inMemoryCache[name]!!.isEmpty()) {
                _inMemoryCache[name] = file.inputStream().readBytes()
            }

            val now = Calendar.getInstance().time.time
            val modified = file.lastModified()

            if ((now - modified) / 60000 > _nMinutesCacheTimeout) {
                add(loadFromStorage(name), name)
            }
        }
        else
        {
            add(loadFromStorage(name), name)
        }

        return@coroutineScope _inMemoryCache[name]!!
    }

    private suspend fun loadFromStorage(name: String): ByteArray{
        return _cacheUpdaterSource.child(name).getBytes(2 * 1024 * 1024).await()
    }
}