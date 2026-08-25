# Powershell Focus SIS Scraper
An open-source web scraper for Focus SIS. It handles user authentication, session persistence, and organizes student data locally to be used in other applications.

Focus Student Information Systems (SIS) does not offer a public API for students or developers to use, unlike Canvas by Instructure or other educational applications.

This middleware was therefore made for that exact purpose; scraping information from Focus SIS for use in other projects for students and developers.

There are future plans of creating a second, multi-lingual version of this program. As of now, this is only for Powershell 5.1+.

## How It Works
A .NET WebSession (`Microsoft.PowerShell.Commands.WebRequestSession`) is created to store cookies.

Powershell's `Invoke-WebRequest` is used to authenticate, grab links available on the principle page and grab the authenticated student's data.

This data, as well as the WebSession are both saved so they can be reused without another authentication, or no authentication at all.

## Configuration & Prerequisites

Powershell 5.1+ is required.
No configuration is necessary yet.

## File Structure

`README.md` - This document

`MainApp.ps1` - Contains the primary logic

`Scripts\` - Contains auth and other necessary scripts

`Helpers\` - Keeps Getters and other organized functions
