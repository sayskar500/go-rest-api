package config

import (
	"flag"
	"log"
	"os"

	CLEANENV "github.com/ilyakaznacheev/cleanenv"
)

type HTTPServer struct {
	Addr string `yaml:"address"`
}

type Config struct {
	Env         string     `yaml:"env" env-required:"true"`
	StoragePath string     `yaml:"storage_path" env-required:"true"`
	HttpServer  HTTPServer `yaml:"http_server"`
}

func MustLoad() *Config {
	var configPath string

	configPath = os.Getenv("CONFIG_PATH")

	if configPath == "" {
		flags := flag.String("config", "", "path to the configuration file")
		flag.Parse()

		configPath = *flags

		if configPath == "" {
			log.Fatal("Config path is not set")
		}
	}

	if _, err := os.Stat(configPath); os.IsNotExist(err) {
		log.Fatalf("config file does not exist: %s.\n", configPath)
	}

	var cfg Config

	err := CLEANENV.ReadConfig(configPath, &cfg)
	if err != nil {
		log.Fatalf("can not read config file: %s.\n", err.Error())
	}

	return &cfg
}
