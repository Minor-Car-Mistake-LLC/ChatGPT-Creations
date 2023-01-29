import android.content.Intent
import android.net.Uri

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val website = "http://minorcarmistake.com"
        val openURL = Intent(Intent.ACTION_VIEW)
        openURL.data = Uri.parse(website)
        startActivity(openURL)
    }
}