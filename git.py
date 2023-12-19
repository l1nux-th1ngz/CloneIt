import tkinter as tk
from tkinter import filedialog
import os
from git import Repo

class GitDownloaderApp:
    def __init__(self, master):
        self.master = master
        self.master.title("GIT Downloader")
        self.master.geometry("400x300")

        self.repo_list = tk.Listbox(self.master, selectmode=tk.MULTIPLE)
        self.repo_list.pack(expand=True, fill=tk.BOTH)

        self.add_button = tk.Button(self.master, text="Add Repository", command=self.add_repository)
        self.add_button.pack(pady=10)

        self.fetch_button = tk.Button(self.master, text="Fetch Repositories", command=self.fetch_repositories)
        self.fetch_button.pack(pady=10)

        self.clone_directory = ""

    def add_repository(self):
        repo_url = filedialog.askstring("Add Repository", "Enter Git Repository URL:")
        if repo_url:
            self.repo_list.insert(tk.END, repo_url)

    def fetch_repositories(self):
        self.clone_directory = filedialog.askdirectory(title="Select Directory to Clone Repositories")
        if not self.clone_directory:
            return

        for index in self.repo_list.curselection():
            repo_url = self.repo_list.get(index)
            self.clone_repository(repo_url)

        tk.messagebox.showinfo("Fetch Complete", "Repositories have been fetched successfully!")

    def clone_repository(self, repo_url):
        try:
            repo_name = repo_url.split("/")[-1].split(".git")[0]
            clone_path = os.path.join(self.clone_directory, repo_name)
            Repo.clone_from(repo_url, clone_path)
        except Exception as e:
            tk.messagebox.showerror("Error", f"Failed to clone {repo_url}: {str(e)}")


if __name__ == "__main__":
    root = tk.Tk()
    app = GitDownloaderApp(root)
    root.mainloop()
