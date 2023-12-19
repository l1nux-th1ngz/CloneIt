import os
import tkinter as tk
from tkinter import messagebox

def clone_repo():
    repo_url = url_entry.get()
    if repo_url:
        os.system(f'git clone {repo_url}')
        messagebox.showinfo("Success", f"Successfully cloned {repo_url}")
    else:
        messagebox.showerror("Error", "Please enter a repository URL")

root = tk.Tk()
root.title("GIT-Downloader")

frame = tk.Frame(root)
frame.pack(padx=10, pady=10)

url_label = tk.Label(frame, text="Enter Repository URL:")
url_label.pack(side=tk.LEFT)

url_entry = tk.Entry(frame, width=50)
url_entry.pack(side=tk.LEFT)

clone_button = tk.Button(frame, text="Clone", command=clone_repo)
clone_button.pack(side=tk.LEFT)

root.mainloop()
