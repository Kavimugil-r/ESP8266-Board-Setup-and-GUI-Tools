Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "Open Serial Monitor"
$form.Size = New-Object System.Drawing.Size(300,200)

$comboPort = New-Object System.Windows.Forms.ComboBox
$comboPort.Location = New-Object System.Drawing.Size(20,30)
$comboPort.Size = New-Object System.Drawing.Size(240,30)
$comboPort.Items.AddRange([System.IO.Ports.SerialPort]::GetPortNames())
$comboPort.SelectedIndex = 0

$comboBaud = New-Object System.Windows.Forms.ComboBox
$comboBaud.Location = New-Object System.Drawing.Size(20,70)
$comboBaud.Size = New-Object System.Drawing.Size(240,30)
$comboBaud.Items.AddRange(@("9600","115200","57600","74880","38400","19200","4800","2400","1200"))
$comboBaud.SelectedIndex = 1

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Size(90,110)
$button.Size = New-Object System.Drawing.Size(100,30)
$button.Text = "Start Monitor"
$button.Add_Click({
    $port = $comboPort.SelectedItem
    $baud = $comboBaud.SelectedItem
    Start-Process "python" -ArgumentList "-m serial.tools.miniterm $port $baud"
    $form.Close()
})

$form.Controls.AddRange(@($comboPort, $comboBaud, $button))
$form.ShowDialog()
