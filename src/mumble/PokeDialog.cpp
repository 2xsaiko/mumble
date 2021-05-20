#include "PokeDialog.h"

PokeDialog::PokeDialog(QWidget *parent)
	: QDialog(parent), Ui::PokeDialog(), pokes(new QMap< QString, unsigned int >()) {
	this->setupUi(this);
}

void PokeDialog::addPoke(const QString& username) {
	this->pokes->size();
    (*this->pokes)[username] += 1;
	this->updateText();
	this->open();
	this->raise();
}

void PokeDialog::updateText() {
	if (this->pokes->isEmpty()) {
		this->plainTextEdit->setPlainText(tr("Someone poked you!"));
	} else if (this->pokes->size() == 1) {
		this->plainTextEdit->setPlainText(tr("%1 poked you!").arg(this->pokes->firstKey()));
	} else {
		this->plainTextEdit->setPlainText(tr("Several people have poked you!"));
	}
}

void PokeDialog::muteClicked() {
	this->pokes->clear();
	this->close();
}

void PokeDialog::joinClicked() {
	this->pokes->clear();
	this->close();
}

void PokeDialog::accept() {
	this->pokes->clear();
	QDialog::accept();
}
