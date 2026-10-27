function Get-InitialContext {
    return $global:StudentData[0]
}

function Get-DistrictNews {
    return $global:StudentData[2][0].district.news
}

function Get-DistrictPosts {
    return $global:StudentData[2][0].district.posts
}

function Get-CheckInBlock {
    return $global:StudentData[2][0].check_in
}

function Get-CustomBlocks {
    return $global:StudentData[2][0].custom_blocks
}

function Get-StudentEnrollments {
    return $global:StudentData[2][0].enrollments[0].grades
}

function Get-StudentGrades {
    return $global:StudentData[2][0].enrollments[0].grades
}

function Get-EnrollmentPlanner {
    return $global:StudentData[2][0].enrollments[0].mps
}

function Get-EnrollmentReports {
    return $global:StudentData[2][0].enrollments[0].gtide
}
