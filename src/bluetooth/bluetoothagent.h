// This file is part of glacier-home, a nice user experience for NemoMobile.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Copyright (c) 2020, Chupligin Sergey <neochapay@gmail.com>

#ifndef BLUETOOTHAGENT_H
#define BLUETOOTHAGENT_H

#include <QObject>
#include <QDBusObjectPath>

#include <agent.h>
#include <adapter.h>

#include <request.h>
#include <manager.h>
#include <pendingcall.h>

class BluetoothAgent : public BluezQt::Agent
{
    Q_OBJECT

public:
    BluetoothAgent(QObject *parent = Q_NULLPTR);
    QDBusObjectPath objectPath() const;
    Capability capability() const;

    void requestConfirmation(BluezQt::DevicePtr device, const QString &passkey, const BluezQt::Request<> &request);
    void requestAuthorization(BluezQt::DevicePtr device, const BluezQt::Request<> &request);
    void authorizeService(BluezQt::DevicePtr device, const QString &uuid, const BluezQt::Request<> &request);

    void requestPinCode(BluezQt::DevicePtr device, const BluezQt::Request<QString> &request);
    void displayPinCode(BluezQt::DevicePtr device, const QString &pinCode);

    void requestPasskey(BluezQt::DevicePtr device, const BluezQt::Request<quint32> &request);
    void displayPasskey(BluezQt::DevicePtr device, const QString &passkey, const QString &entered);

    void cancel();
    void release();

    Q_INVOKABLE void registerAgent();

    Q_INVOKABLE void pair(const QString &btMacAddress);
    Q_INVOKABLE void unPair(const QString &btMacAddress);

    Q_INVOKABLE void connectDevice(const QString &btMacAddress);

signals:
    void adapterAdded(const BluezQt::AdapterPtr adapter);
    void showRequiesDialog(const QString btMacAddres, const QString name, const QString code);

private:
    void initManagerJobResult(BluezQt::InitManagerJob *job);
    void registerAgentFinished(BluezQt::PendingCall *call);
    void requestDefaultAgentFinished(BluezQt::PendingCall *call);

    void usableAdapterChanged(BluezQt::AdapterPtr adapter);
    void connectToDevice(BluezQt::PendingCall *call);

    BluezQt::Manager *m_manager;
    BluezQt::AdapterPtr m_usableAdapter;
};

#endif // BLUETOOTHAGENT_H
