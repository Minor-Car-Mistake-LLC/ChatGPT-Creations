import ffmpeg
import os
import subprocess
from pytube import YouTube

def get_length(filename):
    result = subprocess.run(["ffprobe", "-v", "error", "-show_entries",
                             "format=duration", "-of",
                             "default=noprint_wrappers=1:nokey=1", filename],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
    return float(result.stdout.decode().strip())

video = input("What is the direct path/Youtube link to the video you want to kill?\nLinux Ex: I HATE THIS BIRD.mp4\nWindows Ex: C/Users/isaac/Videos/I HATE THIS BIRD.mp4\n")
name = input("What do you want the video to be named?\n")

if "https://" in video:
    yt = YouTube(video)
    yt.streams.filter(file_extension='mp4')
    YouTube(video).streams.first().download(filename='video.mp4')
    video = "video.mp4"

size = os.path.getsize(video) 
length = get_length(video)

stream = ffmpeg.input(video)
stream = ffmpeg.output(stream, f"{name}.mp4",video_bitrate=size/length/2.1,audio_bitrate=size/length/3)

try:
    ffmpeg.run(stream)
except Exception as e:
    ffmpeg_dir = input("You don't seem to have ffmpeg set as a PATH environment variable. Where is your ffmpeg.exe?\n")
    os.environ['path'] = ffmpeg_dir
    try:
        ffmpeg.run(stream)
    except Exception as e:
        print(f"An error occurred: {e}")

os.open(f"{name}.mp4", os.O_RDWR)
