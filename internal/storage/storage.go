package storage

import "github.com/sayskar500/go-rest-api/internal/types"

type Storage interface {
	CreateStudent(name, email string, age int) (int64, error)
	GetStudentByID(id int64) (types.Student, error)
	GetStudents() ([]types.Student, error)
}
