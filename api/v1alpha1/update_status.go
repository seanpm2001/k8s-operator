/*
 * The Alluxio Open Foundation licenses this work under the Apache License, version 2.0
 * (the "License"). You may not use this work except in compliance with the License, which is
 * available at www.apache.org/licenses/LICENSE-2.0
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied, as more fully set forth in the License.
 *
 * See the NOTICE file distributed with this work for information regarding copyright ownership.
 */

package v1alpha1

type UpdatePhase string

const (
	UpdatePhaseNone     UpdatePhase = ""
	UpdatePhaseWaiting  UpdatePhase = "Waiting for data to be ready"
	UpdatePhaseUpdating UpdatePhase = "Updating"
	UpdatePhaseUpdated  UpdatePhase = "Updated"
	UpdatePhaseFailed   UpdatePhase = "Failed"
)

// UpdateStatus defines the observed state of Update
type UpdateStatus struct {
	Phase UpdatePhase `json:"phase"`
}
