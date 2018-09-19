//
//  Reconciler.swift
//  UILib
//
//  Created by Benji Encz on 5/16/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

/**
 Derives a set of changes based on a old and new `ComponentContainer`.
*/
public func diffChanges(_ oldTree: ComponentContainer, newTree: ComponentContainer) -> Changes {
    var changes: [Changes] = []

    for component in oldTree.children {
        if component is ComponentContainer {
            // start out with the assumption that we need to update none of the container
            // components
            changes.append(.none)
        } else {
            // start out with the assumption that we need to update every regular component
            changes.append(.update)
        }
    }

    // Use dwifft to compare the old to the new tree
    let diff = oldTree.children.map{ $0.componentIdentifier }
        .diff(newTree.children.map { $0.componentIdentifier })

    var insertedIndexes: [Int] = []
    var removedIndexes: [Int] = []

    // Iterate over all changes we found while diffing
    diff.results.forEach { diffStep in
        switch diffStep {
        case let .insert(index, identifier):
            // If we detect insertions, simply append these two our change list
            changes.append(.insert(index: index, identifier: identifier))
            insertedIndexes.append(index)
        case let .delete(index, _):
            // If we detect deletes, place them at the child component index that is about
            // to be deleted. This will override the default value we inserted earlier for 
            // this component.
            changes[index] = .remove(index: index)
            removedIndexes.append(index)
        }
    }

    // Iterate over all components allready in the tree and recursively check for updates
    for (index, component) in oldTree.children.enumerated() {
        // Revisit all old components that currently have a `.None` set of changes
        // Deleted or inserted types don't need to be checked for child component changes since they
        // are either being removed from the tree or are entirely new.
        guard case .none = changes[index] else { continue }

        // Calculate mapping between index in new and old tree by counting insertions and
        // deletions that affect the current index
        let newComponentOffset: Int = {
            let insertOffsets = insertedIndexes.filter { $0 <= index }.count
            let removeOffsets = removedIndexes.filter { $0 < index }.count

            return insertOffsets - removeOffsets
        }()

        // In this step we only care about container components
        if let container = component as? ComponentContainer {
            // Recursively reconcile this child component.
            // It's OK to force cast the new child component here, for now, since we know the new
            // component is of identical type as the old component since that was checked in the 
            // diffing step.
            changes[index] = diffChanges(
                container,
                newTree: newTree.children[index + newComponentOffset] as! ComponentContainer
            )
        }
    }

    // Combine all of the changes on this level into a `Root` change for the container component
    return .root(changes)
}
