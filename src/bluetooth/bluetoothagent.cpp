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

#include "bluetoothagent.h"

#include <device.h>
#include <initmanagerjob.h>

BluetoothAgent::BluetoothAgent(QObject *parent)
    : BluezQt::Agent(parent)
{
    m_manager = new BluezQt::Manager(this);

    BluezQt::InitManagerJob *job = m_manager->init();
    job->start();

    connect(job, &BluezQt::InitManagerJob::result,
            this, &BluetoothAgent::initManagerJobResult);

    connect(m_manager,&BluezQt::Manager::usableAdapterChanged,
            this, &BluetoothAgent::usableAdapterChanged);
}

QDBusObjectPath BluetoothAgent::objectPath() const
{
    return QDBusObjectPath(QStringLiteral("/org/glacier/btagent"));
}

BluezQt::Agent::Capability BluetoothAgent::capability() const
{
    return DisplayYesNo;
}

void BluetoothAgent::registerAgent()
{
    BluezQt::PendingCall *call = m_manager->registerAgent(this);

    qDebug() << "BT: bt agent registring";

    connect(call, &BluezQt::PendingCall::finished,
            this, &BluetoothAgent::registerAgentFinished);

}

void BluetoothAgent::pair(const QString &btMacAddress)
{
    BluezQt::DevicePtr device = m_manager->deviceForAddress(btMacAddress);
    if(!device)
    {
        qWarning() << "BT: Device not found";
        return;
    }

    BluezQt::PendingCall *pcall = m_manager->pairWithDevice(btMacAddress);
    pcall->setUserData(btMacAddress);

    connect(pcall, &BluezQt::PendingCall::finished,
            this, &BluetoothAgent::connectToDevice);
}

void BluetoothAgent::connectDevice(const QString &btMacAddress)
{
    BluezQt::DevicePtr device = m_manager->deviceForAddress(btMacAddress);
    if(!device)
    {
        qWarning() << "BT: Device not found";
        return;
    }

    device->connectToDevice();
}

void BluetoothAgent::connectToDevice(BluezQt::PendingCall *call)
{
    QString btMacAddress = call->userData().toString();
    if(!call->error()) {
        BluezQt::DevicePtr device = m_manager->deviceForAddress(btMacAddress);
        if(device) {
           device->connectToDevice();
        }
    }
}

void BluetoothAgent::unPair(const QString &btMacAddress)
{
    BluezQt::DevicePtr device = m_manager->deviceForAddress(btMacAddress);
    if(!device)
    {
        return;
    }

    m_usableAdapter->removeDevice(device);
}

void BluetoothAgent::usableAdapterChanged(BluezQt::AdapterPtr adapter)
{
    if(adapter)
    {
        emit adapterAdded(adapter);
        m_usableAdapter = adapter;
    }
}

void BluetoothAgent::requestConfirmation(BluezQt::DevicePtr device, const QString &passkey, const BluezQt::Request<> &request)
{
    Q_UNUSED(request);

    emit showRequiesDialog(device->address() ,
                           device->name() ,
                           passkey);
}

void BluetoothAgent::authorizeService(BluezQt::DevicePtr device, const QString &uuid, const BluezQt::Request<> &request)
{
    qWarning() << "TODO";
    qDebug() << "AuthorizeService()" << device->address() << device->name() << uuid;
}

void BluetoothAgent::requestAuthorization(BluezQt::DevicePtr device, const BluezQt::Request<> &request)
{
    qWarning() << "TODO";
    qDebug() << "RequestAuthorization()" << device->address() << device->name();
}

void BluetoothAgent::requestPinCode(BluezQt::DevicePtr device, const BluezQt::Request<QString> &request)
{
    qWarning() << "TODO";
    qDebug() << "RequestPinCode()" << device->address() << device->name();
}

void BluetoothAgent::displayPinCode(BluezQt::DevicePtr device, const QString &pinCode)
{
    qWarning() << "TODO";
    qDebug() << "DisplayPinCode()" << device->address() << device->name() << pinCode;
}

void BluetoothAgent::requestPasskey(BluezQt::DevicePtr device, const BluezQt::Request<quint32> &request)
{
    qWarning() << "TODO";
    qDebug() << "RequestPasskey()" << device->address() << device->name();
}

void BluetoothAgent::displayPasskey(BluezQt::DevicePtr device, const QString &passkey, const QString &entered)
{
    qWarning() << "TODO";
    qDebug() << "DisplayPasskey()" << device->address() << device->name() << passkey << entered;
}

void BluetoothAgent::cancel()
{
    qWarning() << "TODO";
    qDebug() << "BlueZ agent: Cancel()";
}

void BluetoothAgent::release()
{
    qWarning() << "TODO";
    qDebug() << "BlueZ agent: Release()";
}

void BluetoothAgent::initManagerJobResult(BluezQt::InitManagerJob *job)
{
    if (job->error())
    {
        qWarning() << "Error initializing Bluetooth manager:" << job->errorText();
    }
}

void BluetoothAgent::registerAgentFinished(BluezQt::PendingCall *call)
{
    if (call->error())
    {
        qWarning() << "BT: registerAgent() call failed:" << call->errorText();
        return;
    }

    BluezQt::PendingCall *pcall = m_manager->requestDefaultAgent(this);
    connect(pcall, &BluezQt::PendingCall::finished,
            this, &BluetoothAgent::requestDefaultAgentFinished);

}

void BluetoothAgent::requestDefaultAgentFinished(BluezQt::PendingCall *call)
{
    if (call->error())
    {
        qWarning() << "BT: requestDefaultAgent() call failed:" << call->errorText();
    }
     qDebug() << "BT: bt agent registring as system" << objectPath().path();
}


