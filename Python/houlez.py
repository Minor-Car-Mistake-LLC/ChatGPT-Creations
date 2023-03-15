from ursina import *
import urllib.request
import webbrowser

class Browser(App):
    def __init__(self):
        super().__init__()

        self.url = "https://www.minorcarmistake.com"

        self.browser_window = window.Window(
            title="MCM Browser",
            content=(
                self.url_bar = TextField(
                    position=(-0.5, 0.4),
                    scale=(2, 0.1),
                    text=self.url,
                    on_submit=self.load_url,
                ),
                self.web_view = Entity(model="quad", texture=self.get_web_page_texture()),
            ),
            resizable=True,
        )

        self.browser_window.fps_counter.enabled = False

    def load_url(self):
        self.url = self.url_bar.text
        self.web_view.texture = self.get_web_page_texture()

    def get_web_page_texture(self):
        try:
            response = urllib.request.urlopen(self.url)
            html = response.read().decode()
            with open("temp.html", "w") as f:
                f.write(html)
            webbrowser.open("temp.html")
            return Texture("temp.html", filtering=False)
        except:
            return Texture("assets/error.png", filtering=False)

if __name__ == "__main__":
    browser = Browser()
    browser.run()
