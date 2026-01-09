package payloads

// Report represents a full exports report sent to the semver service.
type Report struct {
	Version        int               `json:"version"`
	RootKey        string            `json:"root_key"`
	Language       string            `json:"language"`
	IndexerVersion string            `json:"indexer_version"`
	Exports        map[string]Export `json:"exports"`
}
