from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout, QTextEdit, QLineEdit, QDialog, QLabel, QFormLayout, QCheckBox
import os

class LoginDialog(QDialog):
    def __init__(self):
        super().__init__()

        self.setWindowTitle('Login')

        self.email = QLineEdit()
        self.password = QLineEdit()
        self.password.setEchoMode(QLineEdit.Password)
        self.remember = QCheckBox("Remember me")

        layout = QFormLayout()
        layout.addRow(QLabel('Email'), self.email)
        layout.addRow(QLabel('Password'), self.password)
        layout.addRow(self.remember)

        login_button = QPushButton('Login')
        login_button.clicked.connect(self.accept)

        layout.addRow(login_button)

        self.setLayout(layout)

class MyApp(QWidget):
    def __init__(self):
        super().__init__()

        self.initUI()

    def initUI(self):
        # Create a QPushButton
        btn = QPushButton('Submit', self)
        btn.clicked.connect(self.buttonClicked)

        # Create a Save Chat button
        save_btn = QPushButton('Save Chat', self)
        save_btn.clicked.connect(self.saveChat)

        # Create a QTextEdit
        self.textEdit = QTextEdit()
        self.textEdit.setReadOnly(True)

        # Create a QLineEdit
        self.lineEdit = QLineEdit()

        # Create a QVBoxLayout
        vbox = QVBoxLayout()
        vbox.addWidget(self.textEdit)
        vbox.addWidget(self.lineEdit)
        vbox.addWidget(btn)
        vbox.addWidget(save_btn)

        self.setLayout(vbox)

        self.setWindowTitle('ChatGPT GUI')
        self.setGeometry(300, 300, 300, 200)

    def buttonClicked(self):
        # Get the text from the QLineEdit
        text = self.lineEdit.text()

        # TODO: Send 'text' to ChatGPT and get the response

        # Display the response in the QTextEdit
        self.textEdit.append("User: " + text + "\n" + "ChatGPT: " + "Response")

    def saveChat(self):
        # Save the chat history to a .txt file
        with open('chat_history.txt', 'w') as f:
            f.write(self.textEdit.toPlainText())

if __name__ == '__main__':
    app = QApplication([])

    login = LoginDialog()

    if login.exec_() == QDialog.Accepted:
        ex = MyApp()
        ex.show()
        sys.exit(app.exec_())
