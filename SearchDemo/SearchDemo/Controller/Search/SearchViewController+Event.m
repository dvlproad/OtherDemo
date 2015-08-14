//
//  SearchViewController+Event.m
//  Lee
//
//  Created by lichq on 14-12-3.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "SearchViewController+Event.h"

@implementation SearchViewController (Event)

#pragma mark - 搜索结束
- (IBAction)searchFinished:(id)sender{
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSelectWithObject:)]) {
        
        [self.delegate searchViewController:self didSelectWithObject:self.tf.text];
    }
}



#pragma mark - TableView操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self didFinishSearch];
    
    id object = [dataSearchResult objectAtIndex:indexPath.row];
    Bank *bank = [[Bank alloc]initWithDictionary:object];
    NSString *string = [NSString stringWithFormat:@"%@:%@", bank.name, bank.code];
    
    self.tf.text = string;
    
    [self doSearchingText:@""];//这行语句应该写在打印出结果后,防止覆盖掉之前的dataSearchResult
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //tv滑动的时候，始终取消scBar和tf弹出的键盘,以使得可以查看被键盘遮住的tableView区域
    [self.scBar resignFirstResponder];
    [self.tf resignFirstResponder];
}




#pragma mark - searchBar操作
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //[searchBar setShowsCancelButton:YES animated:YES];//显示取消按钮
    
    [self doBeiginSearchByText:searchBar.text];
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self doSearchingText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{//取消键盘
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    //[searchBar setShowsCancelButton:NO animated:YES];//隐藏取消按钮
    
    [self didFinishSearch];
}


#pragma mark - textField操作
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self doBeiginSearchByText:textField.text];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //NSLog(@"tf.text = %@, range = %@, replaceString = %@", textField.text, NSStringFromRange(range), string);
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    [self doSearchingText:newText];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [self doSearchingText:@""];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{//取消键盘
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - 搜索核心
- (void)doBeiginSearchByText:(NSString *)searchText{
    [self.tvSearch setAlpha:1];
    [self doSearchingText:searchText];
}

- (void)didFinishSearch{
    [self.tvSearch setAlpha:0];
    [self.scBar resignFirstResponder];
    [self.tf resignFirstResponder];
}

- (void)doSearchingText:(NSString *)searchText{
    
    if ([searchText isEqualToString:@""]) {
        dataSearchResult = dataSearchHold;
        [self.tvSearch reloadData];
        return;
    }
    
    
    /**< 模糊查找*/
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@ OR %K contains[cd] %@", [Bank keyName], searchText, [Bank keyCode], searchText];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    
    /**< 精确查找*/
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", [Bank keyName], searchText];
    
    
#pragma mark - TODO 汉子转拼音的模糊搜索
    
    dataSearchResult = [dataSearchHold filteredArrayUsingPredicate:predicate];
    [self.tvSearch reloadData];
}



@end
