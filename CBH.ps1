#Powershell GUI to easily make PS comment based help
$synopsis = ""
$description = ""
$parameter = ""
$example = ""
$input = ""
$output = ""
$notes = ""
$link = ""
$component = ""
$role = ""
$functionality = ""
$icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")

# Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssembyName System.Drawing

# Main Form Code
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Comment Based Help GUI"
$Form.Size = New-Object System.Drawing.Size(300, 565)
$Form.StartPosition = "CenterScreen"
$Form.Icon = $icon

# Synopsis code
$SynopsisLabel = New-Object System.Windows.Forms.Label
$SynopsisLabel.Location = New-Object System.Drawing.Point(10,20)
$SynopsisLabel.Size = New-Object System.Drawing.Size(280,20)
$SynopsisLabel.Text = "SYNOPSIS"
$Form.Controls.Add($SynopsisLabel)
$SynopsisTextBox = New-Object System.Windows.Forms.TextBox
$SynopsisTextBox.Location = New-Object System.Drawing.Point(10,40)
$SynopsisTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($SynopsisTextBox)

# Description Code
$DescriptionLabel = New-Object System.Windows.Forms.Label
$DescriptionLabel.Location = New-Object System.Drawing.Point(10,65)
$DescriptionLabel.Size = New-Object System.Drawing.Size(280,20)
$DescriptionLabel.Text = "DESCRIPTION"
$Form.Controls.Add($DescriptionLabel)
$DescriptionTextBox = New-Object System.Windows.Forms.TextBox
$DescriptionTextBox.Location = New-Object System.Drawing.Point(10,85)
$DescriptionTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($DescriptionTextBox)

# Parameter Code
$ParameterLabel = New-Object System.Windows.Forms.Label
$ParameterLabel.Location = New-Object System.Drawing.Point(10,110)
$ParameterLabel.Size = New-Object System.Drawing.Size(280,20)
$ParameterLabel.Text = "PARAMETER"
$Form.Controls.Add($ParameterLabel)
$ParameterTextBox = New-Object System.Windows.Forms.TextBox
$ParameterTextBox.Location = New-Object System.Drawing.Point(10,130)
$ParameterTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($ParameterTextBox)

# Example Code
$ExampleLabel = New-Object System.Windows.Forms.Label
$ExampleLabel.Location = New-Object System.Drawing.Point(10,155)
$ExampleLabel.Size = New-Object System.Drawing.Size(280,20)
$ExampleLabel.Text = "EXAMPLE"
$Form.Controls.Add($ExampleLabel)
$ExampleTextBox = New-Object System.Windows.Forms.TextBox
$ExampleTextBox.Location = New-Object System.Drawing.Point(10,175)
$ExampleTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($ExampleTextBox)

# Input Code
$InputLabel = New-Object System.Windows.Forms.Label
$InputLabel.Location = New-Object System.Drawing.Point(10,200)
$InputLabel.Size = New-Object System.Drawing.Size(280,20)
$InputLabel.Text = "INPUT"
$Form.Controls.Add($InputLabel)
$InputTextBox = New-Object System.Windows.Forms.TextBox
$InputTextBox.Location = New-Object System.Drawing.Point(10,220)
$InputTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($InputTextBox)

# Output Code
$OutputLabel = New-Object System.Windows.Forms.Label
$OutputLabel.Location = New-Object System.Drawing.Point(10,245)
$OutputLabel.Size = New-Object System.Drawing.Size(280,20)
$OutputLabel.Text = "OUTPUT"
$Form.Controls.Add($OutputLabel)
$OutputTextBox = New-Object System.Windows.Forms.TextBox
$OutputTextBox.Location = New-Object System.Drawing.Point(10,265)
$OutputTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($OutputTextBox)

# Notes Code
$NotesLabel = New-Object System.Windows.Forms.Label
$NotesLabel.Location = New-Object System.Drawing.Point(10,290)
$NotesLabel.Size = New-Object System.Drawing.Size(280,20)
$NotesLabel.Text = "NOTES"
$Form.Controls.Add($NotesLabel)
$NotesTextBox = New-Object System.Windows.Forms.TextBox
$NotesTextBox.Location = New-Object System.Drawing.Point(10,310)
$NotesTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($NotesTextBox)

# Links Code
$LinksLabel = New-Object System.Windows.Forms.Label
$LinksLabel.Location = New-Object System.Drawing.Point(10,335)
$LinksLabel.Size = New-Object System.Drawing.Size(280,20)
$LinksLabel.Text = "LINKS"
$Form.Controls.Add($LinksLabel)
$LinksTextBox = New-Object System.Windows.Forms.TextBox
$LinksTextBox.Location = New-Object System.Drawing.Point(10,355)
$LinksTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($LinksTextBox)

# Component Code
$ComponentLabel = New-Object System.Windows.Forms.Label
$ComponentLabel.Location = New-Object System.Drawing.Point(10,380)
$ComponentLabel.Size = New-Object System.Drawing.Size(280,20)
$ComponentLabel.Text = "COMPONENT"
$Form.Controls.Add($ComponentLabel)
$ComponentTextBox = New-Object System.Windows.Forms.TextBox
$ComponentTextBox.Location = New-Object System.Drawing.Point(10,400)
$ComponentTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($ComponentTextBox)

# Role Code
$RoleLabel = New-Object System.Windows.Forms.Label
$RoleLabel.Location = New-Object System.Drawing.Point(10,425)
$RoleLabel.Size = New-Object System.Drawing.Size(280,20)
$RoleLabel.Text = "ROLE"
$Form.Controls.Add($RoleLabel)
$RoleTextBox = New-Object System.Windows.Forms.TextBox
$RoleTextBox.Location = New-Object System.Drawing.Point(10,445)
$RoleTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($RoleTextBox)

# Functionality Code
$FunctionalityLabel = New-Object System.Windows.Forms.Label
$FunctionalityLabel.Location = New-Object System.Drawing.Point(10,470)
$FunctionalityLabel.Size = New-Object System.Drawing.Size(280,20)
$FunctionalityLabel.Text = "FUNCTIONALITY"
$Form.Controls.Add($FunctionalityLabel)
$FunctionalityTextBox = New-Object System.Windows.Forms.TextBox
$FunctionalityTextBox.Location = New-Object System.Drawing.Point(10,490)
$FunctionalityTextBox.Size = New-Object System.Drawing.Size(260,20)
$Form.Controls.Add($FunctionalityTextBox)


$Form.ShowDialog()


$info = '
<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER

.EXAMPLE

.INPUTS

.OUTPUTS

.NOTES

.LINK

.COMPONENT

.ROLE

.FUNCTIONALITY

#>
'