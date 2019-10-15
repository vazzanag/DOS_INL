import { CdkDragDrop } from '@angular/cdk/drag-drop';
import { Location } from '@angular/common';
import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { GetTrainingEventGroup_Item } from '@models/INL.TrainingService.Models/get-training-event-group_item';
import { GetTrainingEvent_Result } from '@models/INL.TrainingService.Models/get-training-event_result';
import { SaveTrainingEventGroupMembers_Param } from '@models/INL.TrainingService.Models/save-training-event-group-members_param';
import { SaveTrainingEventGroup_Param } from '@models/INL.TrainingService.Models/save-training-event-group_param';
import { ProcessingOverlayService } from '@services/processing-overlay.service';
import { TrainingService } from '@services/training.service';
import { Group } from './Group';
import { Participant } from './Participant';
import { MessageDialogModel } from '@components/message-dialog/message-dialog-model';
import { MessageDialogType } from '@components/message-dialog/message-dialog-type';
import { MessageDialogComponent } from '@components/message-dialog/message-dialog.component';
import { MatDialog, MatDialogConfig } from '@angular/material';
import { MessageDialogResult } from '@components/message-dialog/message-diaog-result';

@Component({
    selector: 'app-manage-groups',
    templateUrl: './manage-groups.component.html',
    styleUrls: ['./manage-groups.component.css']
})
export class ManageGroupsComponent implements OnInit {
    private trainingService: TrainingService;
    private processingOverlayService: ProcessingOverlayService;
    private locationService: Location;
    public trainingEventID: number;
    public instructors: Participant[];
    public students: Participant[];
    public groups: Group[];
    public selectedParticipants: Participant[];
    public trainingEvent?: GetTrainingEvent_Result = null;
    public deletableGroupIDs: number[];
    public isDragging = false;
    public showInstructorsList = false;
    public showStudentsList = false;
    public isAutoArrangeEnabled = false;
    public isStartOverEnabled = false;
    public isSaveEnabled = false;
    public canUngroup = false;
    private groupNamesSequence = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
    @ViewChild('numGroupsSelection') numGroupsSelection;

    private messageDialog: MatDialog;

    constructor(activatedRoute: ActivatedRoute, trainingService: TrainingService, processingOverlayService: ProcessingOverlayService, locationService: Location, messageDialog: MatDialog) {
        this.trainingEventID = parseInt(activatedRoute.snapshot.paramMap.get('trainingEventID'));
        this.trainingService = trainingService;
        this.locationService = locationService;
        this.processingOverlayService = processingOverlayService;
        this.instructors = [];
        this.students = [];
        this.groups = [];
        this.selectedParticipants = [];
        this.deletableGroupIDs = [];
        this.messageDialog = messageDialog;
    }

    public ngOnInit() {
        this.load();
    }

    private load() {
        let context = this;
        context.processingOverlayService.StartProcessing("Load", "Loading Data...");
        this.trainingService.GetTrainingEvent(this.trainingEventID)
            .then(trainingEventResult => {
                context.trainingEvent = trainingEventResult;
                this.trainingService.GetTrainingEventInstructorsByTrainingEventID(this.trainingEventID)
                    .then(instructorsResult => {
                        instructorsResult.Collection.forEach(i => {
                            let participant = new Participant(true, i);
                            this.instructors.push(participant);
                        });
                        this.showInstructorsList = this.instructors.length != 0;
                        this.trainingService.GetTrainingEventParticipants(this.trainingEventID)
                            .then(studentsResult => {
                                studentsResult.Collection.forEach(s => {
                                    let participant = new Participant(false, s);
                                    if (s.ParticipantType === 'Student' && !s.RemovedFromEvent) {
                                        this.students.push(participant);
                                    }
                                });
                                this.showStudentsList = this.students.length != 0;
                                this.trainingService.GetTrainingEventGroupsByTrainingEventID(this.trainingEventID)
                                    .then(groupsResult => {
                                        let sortedGroups = groupsResult.Collection.sort((a, b) => {
                                            if (a.GroupName < b.GroupName) { return -1; }
                                            if (a.GroupName > b.GroupName) { return 1; }
                                            return 0;
                                        });
                                        this.numGroupsSelection.nativeElement.value = sortedGroups.length;
                                        this.loadGroups(sortedGroups, {
                                            success: function () {
                                                context.isAutoArrangeEnabled =
                                                    context.groups.length != 0 &&
                                                    context.groups.filter(g => g.participants.length != 0).length == 0;
                                                context.canUngroup = context.groups.length > 0 ? true : false;
                                                context.processingOverlayService.EndProcessing("Load");
                                            },
                                            error: function (error) {
                                                context.processingOverlayService.EndProcessing("Load");
                                                console.error("Error on Load(): ", error);
                                            }
                                        });
                                    })
                                    .catch(error => {
                                        context.processingOverlayService.EndProcessing("Load");
                                        console.error("Error on Load(): ", error);
                                    });
                            })
                            .catch(error => {
                                context.processingOverlayService.EndProcessing("Load");
                                console.error("Error on Load(): ", error);
                            });
                    })
                    .catch(error => {
                        context.processingOverlayService.EndProcessing("Load");
                        console.error("Error on Load(): ", error);
                    });
            })
            .catch(error => {
                context.processingOverlayService.EndProcessing("Load");
                console.error("Error on Load(): ", error);
            });
    }

    private loadGroups(groups: GetTrainingEventGroup_Item[], callback) {
        this.loadGroup(groups, 0, callback);
    }

    private loadGroup(groups: GetTrainingEventGroup_Item[], index: number, callback) {
        if (index < groups.length) {
            let group = groups[index];
            let uiGroup = new Group();
            uiGroup.id = group.TrainingEventGroupID;
            uiGroup.name = group.GroupName;
            this.groups.push(uiGroup);
            this.trainingService.GetTrainingEventGroupMembersByTrainingEventGroupID(this.trainingEventID, group.TrainingEventGroupID)
                .then(membersResult => {
                    membersResult.Collection.forEach(member => {
                        if (member.MemberTypeID != 1) { // Not Instructor
                            let foundStudents = this.students.filter(s => s.data.PersonID == member.PersonID);
                            if (foundStudents.length > 0) {
                                let foundStudent = foundStudents[0];
                                this.removeItemFromArray(this.students, foundStudent);
                                uiGroup.participants.push(foundStudent);
                            }
                        } else {
                            let foundInstructors = this.instructors.filter(s => s.data.PersonID == member.PersonID);
                            if (foundInstructors.length > 0) {
                                let foundInstructor = foundInstructors[0];
                                let copy = new Participant(true, foundInstructor.data);
                                uiGroup.participants.push(copy);
                            }
                        }
                    });
                    uiGroup.refreshStats();
                    this.loadGroup(groups, index + 1, callback);
                })
                .catch(error => {
                    callback.error(error);
                });
        } else {
            callback.success();
        }
    }

    private renameGroups() {
        for (var i = 0; i < this.groups.length; i++) {
            let letter = this.groupNamesSequence[i];
            let name = `Group ${letter}`;
            this.groups[i].name = name;
        }
    }

    public onNumGroupsChange(numGroups: number) {
        let previousNumGroups = this.groups.length;
        if (previousNumGroups < numGroups) {
            let numGroupsDiff = numGroups - previousNumGroups;
            for (var i = 0; i < numGroupsDiff; i++) {
                let group = new Group();
                if (this.deletableGroupIDs.length > 0)
                    group.id = this.deletableGroupIDs.pop();
                this.groups.push(group);
            }
            this.renameGroups();
        }
        else {
            let spliceIndex = numGroups;
            let numGroupsDiff = previousNumGroups - numGroups;
            let removedGroups = this.groups.splice(spliceIndex, numGroupsDiff);
            removedGroups.forEach(group => {
                group.participants.forEach(participant => {
                    if (!participant.isInstructor)
                        this.students.push(participant);
                });
                if (group.id)
                    this.deletableGroupIDs.push(group.id);
            });
        }
        // Enable auto-arrange if `numGroups` is not 0 and all the groups are empty
        this.isAutoArrangeEnabled = numGroups != 0 && this.groups.filter(g => g.participants.length != 0).length == 0;
        this.isStartOverEnabled = true;
        this.refreshIsSaveEnabled();
    }

    private refreshIsSaveEnabled() {
        this.isSaveEnabled = this.students.length == 0;
        if (!this.isSaveEnabled)
            return;
        let numGroups = this.groups.length;
        for (let i = 0; i < numGroups; i++) {
            let group = this.groups[i];
            let isComplete = (group.numAlternateTypes > 0 || group.numParticipantTypes > 0 || group.numInstructorTypes > 0);
            if (!isComplete) {
                this.isSaveEnabled = false;
                return;
            }
        }
    }

    public onParticipantsDragStart() {
        this.isDragging = true;
    }

    public onParticipantsDragRelease() {
        this.isDragging = false;
    }

    private refreshSelectedParticipants() {
        this.selectedParticipants = [];
        this.instructors.forEach(instructor => {
            if (instructor.isSelected)
                this.selectedParticipants.push(instructor);
        });
        this.students.forEach(student => {
            if (student.isSelected)
                this.selectedParticipants.push(student);
        });
        this.groups.forEach(group => {
            group.participants.forEach(participant => {
                if (participant.isSelected)
                    this.selectedParticipants.push(participant);
            });
        });
    }

    public onIntoInstructorsDrop(event: CdkDragDrop<Participant[]>) {
        let removeInstructors: Participant[] = [];
        this.groups.forEach(group => {
            group.participants.forEach(participant => {
                if (participant.isInstructor && participant.isSelected)
                    removeInstructors.push(participant);
            })
        });
        removeInstructors.forEach(instructor => {
            this.groups.forEach(group => {
                let removed = this.removeItemFromArray(group.participants, instructor);
                if (removed)
                    group.refreshStats();
            });
        });
        if (removeInstructors.length != 0) {
            this.isStartOverEnabled = true;
            this.refreshIsSaveEnabled();
        }
        this.refreshSelectedParticipants();
    }

    public onIntoStudentsDrop(event: CdkDragDrop<Participant[]>) {
        let toArray = event.container.data;
        let moveStudents: Participant[] = [];
        this.groups.forEach(group => {
            group.participants.forEach(participant => {
                if (!participant.isInstructor && participant.isSelected)
                    moveStudents.push(participant);
                else
                    participant.isSelected = false;
            })
        });
        moveStudents.forEach(student => {
            this.groups.forEach(group => {
                let removed = this.removeItemFromArray(group.participants, student);
                if (removed) {
                    group.refreshStats();
                    toArray.splice(event.currentIndex, 0, student);
                }
            });
        });
        if (moveStudents.length != 0) {
            this.isStartOverEnabled = true;
            this.refreshIsSaveEnabled();
        }
        this.refreshSelectedParticipants();
    }

    public onIntoGroupEnter(group: Group) {
        this.groups.forEach(group => {
            group.isTargeted = false;
        });
        group.isTargeted = true;
    }

    public onFromGroupExit(group: Group) {
        group.isTargeted = false;
    }

    public onIntoGroupDrop(group: Group, event: CdkDragDrop<Participant[]>) {
        let fromArray = event.previousContainer.data;
        let toArray = event.container.data;
        let madeChanges = false;
        if (fromArray == this.instructors || fromArray == this.students) {
            let copyInstructors = this.instructors.filter(i => i.isSelected);
            let moveStudents = this.students.filter(s => s.isSelected);
            copyInstructors.forEach(instructor => {
                let alreadyCopied = toArray.filter(p => p.isInstructor && p.data.PersonID == instructor.data.PersonID).length != 0;
                if (!alreadyCopied) {
                    let copy = new Participant(true, instructor.data);
                    copy.isSelected = true;
                    toArray.splice(event.currentIndex, 0, copy);
                    madeChanges = true;
                }
                instructor.isSelected = false;
            });
            moveStudents.forEach(student => {
                let removed = this.removeItemFromArray(this.students, student);
                if (removed) {
                    toArray.splice(event.currentIndex, 0, student);
                    madeChanges = true;
                }
            });
        } else {
            let editGroups = this.groups.filter(g => g.participants != toArray);
            editGroups.forEach(editGroup => {
                let moveParticipants = editGroup.participants.filter(p => p.isSelected);
                moveParticipants.forEach(participant => {
                    let alreadyContains = toArray.filter(p => p.data.PersonID == participant.data.PersonID).length != 0;
                    if (!alreadyContains) {
                        this.removeItemFromArray(editGroup.participants, participant);
                        toArray.splice(event.currentIndex, 0, participant);
                        editGroup.refreshStats();
                        madeChanges = true;
                    }
                });
            });
        }
        if (madeChanges) {
            group.refreshStats();
            this.isAutoArrangeEnabled = false;
            this.isStartOverEnabled = true;
            this.refreshIsSaveEnabled();
        }
        group.isTargeted = false;
        this.refreshSelectedParticipants();
    }

    public onStartOverClick() {

        let dialogData: MessageDialogModel = {
            title: "Confirmation",
            message: "Are you sure you want to reset the created groups?",
            positiveLabel: "Yes",
            negativeLabel: "No",
            type: MessageDialogType.Warning,
            isHTML: true
        };
        this.messageDialog.open(MessageDialogComponent, {
            width: '420px',
            height: '190px',
            data: dialogData,
            panelClass: 'gtts-dialog'
        }).afterClosed()
            .subscribe((result: MessageDialogResult) => {
                if (result == MessageDialogResult.Positive) {
                    this.instructors = [];
                    this.students = [];
                    this.groups = [];
                    this.deletableGroupIDs = [];
                    this.isStartOverEnabled = false;
                    this.isSaveEnabled = false;
                    this.load();
                }
            });
    }

    public onAutoArrangeClick() {
        // Quick internal class that allows me to map an array of participants to a unit ID
        class UnitIDParticipants {
            public unitID: number;
            public participants: Participant[];

            constructor() {
                this.participants = [];
            }
        }
        let participantTypeStudents = this.students.filter(s => s.data.IsParticipant);
        let alternateTypeStudents = this.students.filter(s => !s.data.IsParticipant);
        let numInstructors = this.instructors.length;
        let numStudents = this.students.length;
        let numParticipantTypeStudents = participantTypeStudents.length;
        let numAlternateTypeStudents = alternateTypeStudents.length;
        let numGroups = this.groups.length;
        // Group the participants by unit ID
        let unitIDParticipants: UnitIDParticipants[] = [];
        {
            for (let i = 0; i < numInstructors; i++) {
                let participant = this.instructors[i];
                let unitID = participant.data.UnitID;
                let unit: UnitIDParticipants;
                let foundUnits = unitIDParticipants.filter(uip => uip.unitID == unitID);
                if (foundUnits.length == 0) {
                    unit = new UnitIDParticipants()
                    unit.unitID = unitID;
                    unitIDParticipants.push(unit);
                }
                else
                    unit = foundUnits[0];
                unit.participants.push(participant);
            }
            for (let i = 0; i < numStudents; i++) {
                let participant = this.students[i];
                let unitID = participant.data.UnitID;
                let unit: UnitIDParticipants;
                let foundUnits = unitIDParticipants.filter(uip => uip.unitID == unitID);
                if (foundUnits.length == 0) {
                    unit = new UnitIDParticipants()
                    unit.unitID = unitID;
                    unitIDParticipants.push(unit);
                }
                else
                    unit = foundUnits[0];
                unit.participants.push(participant);
            }
        }
        // Sort the unit IDs. The unit IDs with the most participants go to the front of the array.
        let unitIDParticiantsByParticipantsCount = unitIDParticipants.sort((a, b) => b.participants.length - a.participants.length);
        // The minimum of instructors each group will have.
        let minInstructorsPerGroup = Math.floor(numInstructors / numGroups);
        // The maximum of instructors a group can have after `instructorsRemainder` has been equally distributed among some groups.
        let maxInstructorsPerGroup = minInstructorsPerGroup + 1;
        // The remainder of instructors after all groups have been populated with exactly `minInstructorsPerGroup` number of instructors.
        // This number will be decreased one by one with each group that reaches `maxInstructorsPerGroup` number of instructors.
        let instructorsRemainder = numInstructors % numGroups;
        let minParticipantTypesPerGroup = Math.floor(numParticipantTypeStudents / numGroups);
        let maxParticipantTypesPerGroup = minParticipantTypesPerGroup + 1;
        let participantTypesRemainder = numParticipantTypeStudents % numGroups;
        let minAlternateTypesPerGroup = Math.floor(numAlternateTypeStudents / numGroups);
        let maxAlternateTypesPerGroup = minAlternateTypesPerGroup + 1;
        let alternateTypesRemainder = numAlternateTypeStudents % numGroups;
        for (let i = 0; i < numGroups; i++) {
            let group = this.groups[i];
            // Whether the unit ID with the most participants in this group has been exhausted.
            // When this is the case, the remaining participants to be added to this group should come from the least common unit IDs.
            let clearedFrontUnit = false;
            // Start processing instructors.
            if (unitIDParticiantsByParticipantsCount.length > 0) {
                let addParticipants: Participant[] = [];
                // The unit with the most participants at the moment
                let frontUnit = unitIDParticiantsByParticipantsCount[0];
                // While there are participants in this unit to evaluate and (we havent't fullfilled this group's minimum of instructors, or we have, but there's still more room for some from `instructorsRemainder`)
                for (let j = 0; j < frontUnit.participants.length && (addParticipants.length < minInstructorsPerGroup || (addParticipants.length < maxInstructorsPerGroup && instructorsRemainder != 0)); j++) {
                    let participant = frontUnit.participants[j];
                    if (participant.isInstructor) {
                        addParticipants.push(participant);
                        frontUnit.participants.splice(j, 1);
                        j--;
                    }
                }
                clearedFrontUnit = frontUnit.participants.length == 0;
                if (clearedFrontUnit)
                    // We have distributed all of this unit's participants. Dispose of it.
                    unitIDParticiantsByParticipantsCount.splice(0, 1);
                // If we haven't fulfilled this group's minimum number of instructors, or have room for more from `instructorsRemainder`, keep adding participants from the least common unit IDs
                for (let k = unitIDParticiantsByParticipantsCount.length - 1; k >= 0 && (addParticipants.length < minInstructorsPerGroup || (addParticipants.length < maxInstructorsPerGroup && instructorsRemainder != 0)); k--) {
                    let lastUnit = unitIDParticiantsByParticipantsCount[k];
                    for (let j = 0; j < lastUnit.participants.length && (addParticipants.length < minInstructorsPerGroup || (addParticipants.length < maxInstructorsPerGroup && instructorsRemainder != 0)); j++) {
                        let participant = lastUnit.participants[j];
                        if (participant.isInstructor) {
                            addParticipants.push(participant);
                            lastUnit.participants.splice(j, 1);
                            j--;
                        }
                    }
                    if (lastUnit.participants.length == 0)
                        // We have distributed all of this unit's participants. Dispose of it.
                        unitIDParticiantsByParticipantsCount.splice(k, 1);
                }
                let numParticipantsToAdd = addParticipants.length;
                if (numParticipantsToAdd > minInstructorsPerGroup)
                    // This group got one instructor from `instructorsRemainder`. Decrease `instructorsRemainder` accordingly.
                    instructorsRemainder--;
                for (let j = 0; j < numParticipantsToAdd; j++) {
                    let toAdd = addParticipants[j];
                    toAdd.isSelected = false;
                    let copy = new Participant(true, toAdd.data);
                    group.participants.push(copy);
                }
                group.refreshStats();
            }
            // Repeat similar process for participant-type students.
            if (unitIDParticiantsByParticipantsCount.length > 0) {
                let addParticipants: Participant[] = [];
                // If this unit hasn't been cleared, continue business as usual.
                // Otherwise, skip grabbing participants from the most common unit IDs, and grab from the least common instead.
                // This makes it less likely that this group gets mixed up with participants from another unit ID, when those participants are better off in their own group.
                if (!clearedFrontUnit) {
                    let frontUnit = unitIDParticiantsByParticipantsCount[0];
                    for (let j = 0; j < frontUnit.participants.length && (addParticipants.length < minParticipantTypesPerGroup || (addParticipants.length < maxParticipantTypesPerGroup && participantTypesRemainder != 0)); j++) {
                        let participant = frontUnit.participants[j];
                        if (!participant.isInstructor && participant.data.IsParticipant) {
                            addParticipants.push(participant);
                            frontUnit.participants.splice(j, 1);
                            j--;
                        }
                    }
                    clearedFrontUnit = frontUnit.participants.length == 0;
                    if (clearedFrontUnit)
                        unitIDParticiantsByParticipantsCount.splice(0, 1);
                }
                for (let k = unitIDParticiantsByParticipantsCount.length - 1; k >= 0 && (addParticipants.length < minParticipantTypesPerGroup || (addParticipants.length < maxParticipantTypesPerGroup && participantTypesRemainder != 0)); k--) {
                    let lastUnit = unitIDParticiantsByParticipantsCount[k];
                    for (let j = 0; j < lastUnit.participants.length && (addParticipants.length < minParticipantTypesPerGroup || (addParticipants.length < maxParticipantTypesPerGroup && participantTypesRemainder != 0)); j++) {
                        let participant = lastUnit.participants[j];
                        if (!participant.isInstructor && participant.data.IsParticipant) {
                            addParticipants.push(participant);
                            lastUnit.participants.splice(j, 1);
                            j--;
                        }
                    }
                    if (lastUnit.participants.length == 0)
                        unitIDParticiantsByParticipantsCount.splice(k, 1);
                }
                let numParticipantsToAdd = addParticipants.length;
                if (numParticipantsToAdd > minParticipantTypesPerGroup)
                    participantTypesRemainder--;
                for (let j = 0; j < numParticipantsToAdd; j++) {
                    let toAdd = addParticipants[j];
                    toAdd.isSelected = false;
                    group.participants.push(toAdd);
                }
                group.refreshStats();
            }
            // Repeat similar process for alternate-type students.
            if (unitIDParticiantsByParticipantsCount.length > 0) {
                let addParticipants: Participant[] = [];
                if (!clearedFrontUnit) {
                    let frontUnit = unitIDParticiantsByParticipantsCount[0];
                    for (let j = 0; j < frontUnit.participants.length && (addParticipants.length < minAlternateTypesPerGroup || (addParticipants.length < maxAlternateTypesPerGroup && alternateTypesRemainder != 0)); j++) {
                        let participant = frontUnit.participants[j];
                        if (!participant.isInstructor && !participant.data.IsParticipant) {
                            addParticipants.push(participant);
                            frontUnit.participants.splice(j, 1);
                            j--;
                        }
                    }
                    clearedFrontUnit = frontUnit.participants.length == 0;
                    if (clearedFrontUnit)
                        unitIDParticiantsByParticipantsCount.splice(0, 1);
                }
                for (let k = unitIDParticiantsByParticipantsCount.length - 1; k >= 0 && (addParticipants.length < minAlternateTypesPerGroup || (addParticipants.length < maxAlternateTypesPerGroup && alternateTypesRemainder != 0)); k--) {
                    let lastUnit = unitIDParticiantsByParticipantsCount[k];
                    for (let j = 0; j < lastUnit.participants.length && (addParticipants.length < minAlternateTypesPerGroup || (addParticipants.length < maxAlternateTypesPerGroup && alternateTypesRemainder != 0)); j++) {
                        let participant = lastUnit.participants[j];
                        if (!participant.isInstructor && !participant.data.IsParticipant) {
                            addParticipants.push(participant);
                            lastUnit.participants.splice(j, 1);
                            j--;
                        }
                    }
                    if (lastUnit.participants.length == 0)
                        unitIDParticiantsByParticipantsCount.splice(k, 1);
                }
                let numParticipantsToAdd = addParticipants.length;
                if (numParticipantsToAdd > minAlternateTypesPerGroup)
                    alternateTypesRemainder--;
                for (let j = 0; j < numParticipantsToAdd; j++) {
                    let toAdd = addParticipants[j];
                    toAdd.isSelected = false;
                    group.participants.push(toAdd);
                }
                group.refreshStats();
            }
        }
        this.students.splice(0, this.students.length);
        this.isAutoArrangeEnabled = false;
        this.isStartOverEnabled = true;
        this.refreshIsSaveEnabled();
    }

    public onSaveClick() {
        let allInstructorsAssigned = true;
        let numInstructors = this.instructors.length;
        let numGroups = this.groups.length;
        for (let i = 0; i < numInstructors; i++) {
            let instructor = this.instructors[i];
            let assigned = false;
            for (let j = 0; j < numGroups; j++) {
                let group = this.groups[j];
                let numParticipants = group.participants.length;
                for (let k = 0; k < numParticipants; k++) {
                    let participant = group.participants[k];
                    if (participant.isInstructor && participant.data.PersonID == instructor.data.PersonID) {
                        assigned = true;
                        break;
                    }
                }
                if (assigned)
                    break;
            }
            if (!assigned) {
                allInstructorsAssigned = false;
                break;
            }
        }
        if (!allInstructorsAssigned)
            alert("Not all instructors are assigned to groups.");
        else
            this.save();
    }

    public onUngroupClick() {
        let context = this;

        let dialogData: MessageDialogModel = {
            title: "Confirmation",
            message: "Are you sure you want to delete the created groups?",
            positiveLabel: "Yes",
            negativeLabel: "No",
            type: MessageDialogType.Warning,
            isHTML: true
        };
        this.messageDialog.open(MessageDialogComponent, {
            width: '420px',
            height: '190px',
            data: dialogData,
            panelClass: 'gtts-dialog'
        }).afterClosed()
            .subscribe((result: MessageDialogResult) => {
                if (result == MessageDialogResult.Positive) {
                    context.processingOverlayService.StartProcessing("Save", "Ungrouping...");
                    context.deletableGroupIDs = this.groups.map(g => g.id);
                    context.deleteGroups({
                        success: function () {
                            context.instructors = [];
                            context.students = [];
                            context.groups = [];
                            context.deletableGroupIDs = [];
                            context.isStartOverEnabled = false;
                            context.isSaveEnabled = false;
                            context.processingOverlayService.EndProcessing("Save");
                            context.load();
                        },
                        error: function (error) {
                            context.processingOverlayService.EndProcessing("Save");
                            console.error("Error on onUngroupClick(): ", error);
                        }

                    });
                }
            });
    }

    private save() {
        let context = this;
        context.processingOverlayService.StartProcessing("Save", "Saving Data...");
        context.saveGroups({
            success: function () {
                context.deleteGroups({
                    success: function () {
                        context.processingOverlayService.EndProcessing("Save");
                        context.isStartOverEnabled = false;
                        context.isSaveEnabled = false;
                        context.locationService.back();
                    },
                    error: function (error) {
                        context.processingOverlayService.EndProcessing("Save");
                        console.error("Error on save(): ", error);
                    }
                });
            },
            error: function (error) {
                context.processingOverlayService.EndProcessing("Save");
                console.error("Error on save(): ", error);
            }
        });
    }

    public onCancelClick() {
        this.locationService.back();
    }

    private saveGroups(callback) {
        this.saveGroup(0, callback);
    }

    private saveGroup(index: number, callback) {
        if (index < this.groups.length) {
            let group = this.groups[index];
            let groupParam = new SaveTrainingEventGroup_Param();
            groupParam.TrainingEventID = this.trainingEventID;
            groupParam.TrainingEventGroupID = group.id;
            groupParam.GroupName = group.name;
            this.trainingService.SaveTrainingEventGroup(groupParam)
                .then(saveGroupResult => {
                    group.id = saveGroupResult.Item.TrainingEventGroupID;
                    let groupInstructorsParam = new SaveTrainingEventGroupMembers_Param();
                    groupInstructorsParam.TrainingEventGroupID = group.id;
                    groupInstructorsParam.PersonIDs = group.participants.filter(p => p.isInstructor).map(p => p.data.PersonID);
                    groupInstructorsParam.MemberTypeID = 1; // Instructor
                    this.trainingService.SaveTrainingEventGroupMembers(this.trainingEventID, groupInstructorsParam)
                        .then(_ => {
                            let groupStudentsParam = new SaveTrainingEventGroupMembers_Param();
                            groupStudentsParam.TrainingEventGroupID = group.id;
                            groupStudentsParam.PersonIDs = group.participants.filter(p => !p.isInstructor).map(p => p.data.PersonID);
                            groupStudentsParam.MemberTypeID = 2; // Student
                            this.trainingService.SaveTrainingEventGroupMembers(this.trainingEventID, groupStudentsParam)
                                .then(_ => {
                                    this.saveGroup(index + 1, callback);
                                })
                                .catch(error => {
                                    callback.error(error);
                                });
                        })
                        .catch(error => {
                            callback.error(error);
                        });
                })
                .catch(error => {
                    callback.error(error);
                });
        } else {
            callback.success();
        }
    }

    private deleteGroups(callback) {
        this.deleteGroup(0, callback);
    }

    private deleteGroup(index: number, callback) {
        if (index < this.deletableGroupIDs.length) {
            let deletableGroupID = this.deletableGroupIDs[index];
            this.trainingService.DeleteTrainingEventGroup(this.trainingEventID, deletableGroupID)
                .then(_ => {
                    this.deleteGroup(index + 1, callback);
                })
                .catch(error => {
                    callback.error(error);
                });
        } else {
            this.deletableGroupIDs = [];
            callback.success();
        }
    }

    private removeItemFromArray(array: any[], item: any): boolean {
        const index = array.indexOf(item);
        if (index > -1) {
            array.splice(index, 1);
            return true;
        }
        return false;
    }

    public onParticipantClick(participant: Participant, fromGroups: boolean) {
        if (fromGroups) {
            this.instructors.forEach(instructor => {
                instructor.isSelected = false;
            });
            this.students.forEach(student => {
                student.isSelected = false;
            });
        }
        else {
            this.groups.forEach(group => {
                group.participants.forEach(groupParticipant => {
                    groupParticipant.isSelected = false;
                });
            })
        }
        participant.isSelected = !participant.isSelected;
        this.refreshSelectedParticipants();
    }
}
