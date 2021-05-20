#ifndef MUMBLE_POKEDIALOG_H
#define MUMBLE_POKEDIALOG_H

#include <QDialog>
#include <QMap>
#include <QString>

#include "ui_PokeDialog.h"

class PokeDialog : public QDialog, public Ui::PokeDialog {
private:
	Q_OBJECT

private:
	QMap< QString, unsigned int > pokes;

public:
	PokeDialog(QWidget *parent = nullptr);
	~PokeDialog() = default;

	void addPoke(const QString& username);
	void updateText();

private slots:
    void muteClicked();
	void joinClicked();

public:
	void accept() override;
};

#endif // MUMBLE_POKEDIALOG_H
