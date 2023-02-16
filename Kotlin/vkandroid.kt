import android.os.AsyncTask
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL

class YouTubeDownloadTask(private val videoUrl: String, private val fileName: String) : AsyncTask<Void, Void, Void>() {
    override fun doInBackground(vararg params: Void?): Void? {
        val yt = URL(videoUrl)
        val connection: HttpURLConnection = yt.openConnection() as HttpURLConnection
        connection.requestMethod = "GET"
        connection.doOutput = true
        connection.connect()

        val inputStream = connection.inputStream
        val fileOutputStream = openFileOutput(fileName, Context.MODE_PRIVATE)
        val buffer = ByteArray(1024)
        var length = inputStream.read(buffer)
        while (length != -1) {
            fileOutputStream.write(buffer, 0, length)
            length = inputStream.read(buffer)
        }
        fileOutputStream.close()
        inputStream.close()

        return null
    }
}

class FFmpegTask(private val inputFile: String, private val outputFile: String) : AsyncTask<Void, Void, Void>() {
    override fun doInBackground(vararg params: Void?): Void? {
        val command = arrayOf("ffmpeg", "-i", inputFile, "-c:v", "copy", "-c:a", "copy", outputFile)
        try {
            val process = Runtime.getRuntime().exec(command)
            val reader = BufferedReader(InputStreamReader(process.errorStream))
            var line: String? = reader.readLine()
            while (line != null) {
                line = reader.readLine()
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return null
    }
}

fun main() {
    val videoUrl = readLine()!!.trim()
    val fileName = readLine()!!.trim()
    YouTubeDownloadTask(videoUrl, "video.mp4").execute()
    FFmpegTask("video.mp4", "$fileName.mp4").execute()
}
